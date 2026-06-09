"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLDriver
	instanceVariableNames: 'netSession handshakeInfo'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLDriver guid: (GUID fromString: '{58894997-7763-4046-a84f-cf3aeeac58b0}')!

MySQLDriver comment: 'Driver class for MySQL'!

!MySQLDriver categoriesForClass!MySQL-Core-Driver! !

!MySQLDriver methodsFor!

assertConnection	self connected ifFalse: [^ MySQLNoConnectionError signal: 'Driver is not connected'].	!

changeUser: connSpec 	| com scrmbl |	self assertConnection.	com := MySQLCommandChangeUser onSession: netSession.	scrmbl := MySQLHelper secureScramble: handshakeInfo scrambleBuff , handshakeInfo scrambleBuffMore with: connSpec password .	com		user: connSpec user;		scrambledPassword: scrmbl;		database: connSpec db;		password: connSpec password;		scrambleBuff: handshakeInfo scrambleBuff;		charset: handshakeInfo serverLang.	^ com execute!

commandQueryClass

	^MySQLCommandQuery!

connect: connSpec 	| handshake resp |		self connected ifTrue: [^ MySQLDriverError signal: 'Driver is already connected'].	netSession ifNil: [netSession := MySQLNetworkSession new].	netSession toHost: connSpec host andPort: connSpec port.	handshake := self readHandshake.	self writeAuthForHandshake: handshake onConnection: connSpec.	resp := self peekResponse.	resp isEof ifTrue: [		"Read the send short hash indicator: ainsgle eof(254) byte)"		self readResponse.		"This is an indication that comes from server if the password for this user		follows the old style (short hash) instead of the new style (long hash). 		We need to send back the 323 scramble"		self send323Scramble: handshake scrambleBuff password: connSpec password.		resp := self peekResponse]. 	resp isError ifTrue: [^ MySQLError from: netSession read].	resp isOkay ifTrue: [		self keepHandshakeInfo: handshake.		^ MySQLOkay from: netSession read].		MySQLDriverError signal: 'Unexpected response from server: data is not okay/error/eof'	!

connected	^ netSession isNil not and: [netSession connected]	!

disconnect	self assertConnection.	(MySQLCommandQuit  onSession: netSession) execute.	netSession disconnect.	!

errorFromResponse: resp	^ MySQLError from: resp data!

handshakeInfo	^ handshakeInfo !

keepHandshakeInfo: handshake	handshakeInfo := handshake!

netSession	^ netSession	!

okayFromResponse: resp	^ MySQLOkay from: resp data!

peekResponse	| buffer resp |		buffer := netSession peek.	resp := MySQLPacket from: buffer.	^ resp	!

ping	self assertConnection.	^ (MySQLCommandPing onSession: netSession) execute!

prepare: queryString	| prepStmt prepResp |	self assertConnection.			prepStmt := MySQLCommandPrepare onSession: netSession.	prepStmt queryString: queryString.	prepResp := prepStmt execute. "error or prepare reponse"		^ prepResp!

query: queryString

	self assertConnection.		
	^(self commandQueryClass onSession: netSession)
		queryString: queryString;
		execute!

readHandshake	| buffer handshake |	buffer := netSession read.	handshake := MySQLHandshake from: buffer.	^handshake !

readResponse	| buffer resp |		buffer := netSession read.	resp := MySQLPacket from: buffer.	^ resp!

send323Scramble: seed password: password	| scrmblPkt |	scrmblPkt := MySQL323Scramble new.	scrmblPkt password: password; scrambleBuff: seed.	self writePacket: scrmblPkt.	!

writeAuthForHandshake: handshake onConnection: connSpec	| auth |	handshake supportsProtocol41 		ifTrue: [auth := MySQLClientAuth new]		ifFalse: [MySQLUnsupportedProtocolError signal: 'Server does not support protocol version 41'].		auth		serverCaps: handshake serverCaps ;		charset: handshake serverLang ;		user: connSpec user ;		password: connSpec password ;		database: connSpec db ;		scrambleBuff: handshake scrambleBuff ;		scrambleBuffMore: handshake scrambleBuffMore .			self writePacket: auth !

writePacket: packet	| buffer |		buffer := packet write.	netSession  write: buffer.! !

!MySQLDriver categoriesForMethods!
assertConnection!public!testing! !
changeUser:!accessing!private! !
commandQueryClass!accessing!private! !
connect:!accessing!private! !
connected!public!testing! !
disconnect!accessing!private! !
errorFromResponse:!private! !
handshakeInfo!private! !
keepHandshakeInfo:!private! !
netSession!accessing!private! !
okayFromResponse:!private! !
peekResponse!private! !
ping!accessing!private! !
prepare:!accessing!private! !
query:!accessing!private! !
readHandshake!private! !
readResponse!private! !
send323Scramble:password:!public!scrambling! !
writeAuthForHandshake:onConnection:!private! !
writePacket:!private! !
!

