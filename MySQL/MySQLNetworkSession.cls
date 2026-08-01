"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLNetworkSession
	instanceVariableNames: 'socket nextPacketNumber peekData logStream inputQueue outputQueue process'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLNetworkSession guid: (GUID fromString: '{b2c2fa6c-8873-40ef-a535-a73a2ac184b1}')!

MySQLNetworkSession comment: 'A MySQL Network session'!

!MySQLNetworkSession categoriesForClass!MySQL-Core-Network! !

!MySQLNetworkSession methodsFor!

connected	^ socket ifNil: [false] ifNotNil: [socket isOpen and: [[socket peerAddress. true] on: SocketError do: [ :exc | exc return: false]]] !

disconnect
	self connected ifTrue: [socket close] .
	process ifNotNil: [process terminate].
	logStream ifNotNil: [logStream flush]!

executeCommand: aCommand

	| res |

	inputQueue nextPut: aCommand.
	res := outputQueue next.
	^res!

getSequence	^ nextPacketNumber !

getSequenceAndIncrement
	| prev | 
	prev := nextPacketNumber.
	nextPacketNumber := nextPacketNumber + 1.
	^prev!

initialize	self resetSequence.!

isSecureConnection

	^socket isSecureConnection!

onConnected

	inputQueue := SharedQueue new.
	outputQueue := SharedQueue new.

	process := 
		[[| cmd |
		cmd := inputQueue next.
		logStream ifNotNil: [logStream cr; nextPutAll: 'Executing '; print: cmd].
		self resetSequence.
		cmd send: cmd prepare.
		outputQueue nextPut: cmd readResponse.
		true] whileTrue] forkAt: Processor lowIOPriority!

peek	"Look ahead; don't remove the packet until next read"	peekData ifNil: [peekData := self readPacketData].	^ peekData!

read	| data |	"Return packet from look ahead buffer if any. Clear look ahead buffer"	peekData ifNotNil: [data := peekData. peekData := nil. ^ data].	^ self readPacketData	!

readNetPacket	| pkt |	pkt := MySQLNetworkPacket new.	pkt readFrom: socket readStream.	self validatePacket: pkt.	^ pkt!

readPacketData
	"Read all packets until there are no more packets of data."

	| dataPacket stream |

	"Common case - just one packet"
	(dataPacket  := self readNetPacket) isOfMaxLength ifFalse: [^dataPacket data].

	"More packets - concatenate data"
	stream := WriteStream on: (ByteArray new: dataPacket length * 5).
	stream nextPutAll: dataPacket data.
	
	[dataPacket := self readNetPacket.
	stream nextPutAll: dataPacket data.
	dataPacket isOfMaxLength] whileTrue.	"indicates more packets to follow"

	^stream contents!

resetSequence	nextPacketNumber := 0!

secureConnection

	socket secureConnection!

toHost: host andPort: port 
	
	self resetSequence.
	[socket := TlsSocket port: port host: host.
	socket 
		shouldSecureOnConnect: false;
		isOverlapped: false; "blocking database calls - same as ODBC and SQLite"
		connect.
	"Turn off Nagle algorithm, else response time to short packets would suffer. Thanks to
	Goran Krampe for studying the issue in Ubuntu linux and figure out the details. Ref:
	http://developers.slashdot.org/comments.pl?sid=174457&threshold=1&commentsort=0&mode=thread&cid=14515105 for comments from John Nagle himself."
	socket setBooleanOption: 1 "TCP_NODELAY" level: "IPPROTO_TCP" 6 value: true.
	self onConnected] 
			on: SocketError do: [:ex | MySQLNameLookupFailure signal: ex messageText] !

updateSequence	nextPacketNumber := (nextPacketNumber + 1) bitAnd: 255!

validatePacket: pkt
    "Validate a network packet unit. Currently we validate the sequence number."
    "Update sequence if validation passes"
    (self validateSequence: pkt number)
        ifTrue: [self updateSequence]
        ifFalse: [^ self error: 'Packet sequence validation error <1p> ~= <2p>' << (Array with: pkt number with: nextPacketNumber)]!

validateSequence: pktNumber 	^ pktNumber = nextPacketNumber!

write: data 	self writePacketData: data!

writeNetPacket: pkt	"Write a network packet unit to the underlying stream"	pkt writeTo: socket writeStream!

writePacketData: data 
	| maxSize stream |	
	maxSize := MySQLNetworkPacket.MaxPacketLength.	data size < maxSize ifTrue: [^self writeSinglePacketData: data].

	stream := data readStream.	[(self writeSinglePacketData: (stream nextAvailable: maxSize)) isOfMaxLength] whileTrue!

writeSinglePacketData: data

	| pkt |
	
	pkt := MySQLNetworkPacket new.
	pkt 
		length: data size;
		number: self getSequenceAndIncrement;
		data: data.
			
	self writeNetPacket: pkt.

	^pkt! !

!MySQLNetworkSession categoriesForMethods!
connected!public!testing! !
disconnect!accessing!public! !
executeCommand:!helpers!public! !
getSequence!public!sequence numbering! !
getSequenceAndIncrement!public!sequence numbering! !
initialize!initialize/release!public! !
isSecureConnection!public!testing! !
onConnected!helpers!public! !
peek!public!reading! !
read!public!reading! !
readNetPacket!public!reading! !
readPacketData!public!reading! !
resetSequence!public!sequence numbering! !
secureConnection!helpers!public! !
toHost:andPort:!accessing!public! !
updateSequence!public!sequence numbering! !
validatePacket:!public!reading! !
validateSequence:!public!sequence numbering! !
write:!public!writing! !
writeNetPacket:!public!writing! !
writePacketData:!public!writing! !
writeSinglePacketData:!public!writing! !
!

!MySQLNetworkSession class methodsFor!

new

	^super new initialize! !

!MySQLNetworkSession class categoriesForMethods!
new!instance creation!public! !
!

