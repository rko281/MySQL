"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLClientAuth
	instanceVariableNames: 'user password database scrambleBuff clientCaps charset serverCaps scrambleBuffMore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLClientAuth guid: (GUID fromString: '{4b89f951-96ed-4888-9ca7-260981ea7876}')!

MySQLClientAuth comment: 'Client authentication packet for MySQL'!

!MySQLClientAuth categoriesForClass!MySQL-Core-Packet! !

!MySQLClientAuth methodsFor!

charset: csNum	charset := csNum!

database: db	database := db!

initialize	clientCaps := CapLongFlag + CapTransactions + CapLongPassword + CapConnectWithDb.	clientCaps := clientCaps + CapProtocol41 + CapSecureConnection.!

password: pwd	password := pwd.!

scrambleBuff: buffer	scrambleBuff := buffer.!

scrambleBuffMore: more	scrambleBuffMore := more!

serverCaps: caps 	serverCaps := caps!

user: userName	user := userName!

write	| flags scrmbl buffStream maxNetPacketLength |	buffStream := WriteStream on: (ByteArray new: 1024).	flags := serverCaps bitAnd: clientCaps.	flags := flags bitOr: CapMultiStatements + CapMultiResults.	buffStream		nextPut: (flags byteAt: 1);		nextPut: (flags byteAt: 2);		nextPut: (flags byteAt: 3);		nextPut: (flags byteAt: 4).	maxNetPacketLength := self class maxNetPacketLength.	buffStream		nextPut: (maxNetPacketLength byteAt: 1);		nextPut: (maxNetPacketLength byteAt: 2);		nextPut: (maxNetPacketLength byteAt: 3);		nextPut: (maxNetPacketLength byteAt: 4).	buffStream nextPut: (charset byteAt: 1).	buffStream nextPutAll: (ByteArray new: 23 withAll: 0).	"filler"	buffStream nextPutAll: user asByteArray.	buffStream nextPut: 0.	"null terminated"	scrmbl := MySQLHelper secureScramble: scrambleBuff , scrambleBuffMore with: password .	self encodeLcs: scrmbl on: buffStream.	(flags bitAnd: CapConnectWithDb) = CapConnectWithDb		ifTrue: [ (database ifNil: ['']) isEmpty ifFalse: [ buffStream nextPutAll: database asByteArray ].			buffStream nextPut: 0	"null terminated" ].	^ buffStream contents! !

!MySQLClientAuth categoriesForMethods!
charset:!accessing!public! !
database:!accessing!public! !
initialize!initialization!public! !
password:!accessing!public! !
scrambleBuff:!public!scrambling! !
scrambleBuffMore:!public!scrambling! !
serverCaps:!accessing!public! !
user:!accessing!public! !
write!public!writing! !
!

!MySQLClientAuth class methodsFor!

new

	^super new initialize! !

!MySQLClientAuth class categoriesForMethods!
new!instance creation!public! !
!

