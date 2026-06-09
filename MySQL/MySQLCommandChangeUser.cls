"Filed out from Dolphin Smalltalk"!

MySQLCommandBase subclass: #MySQLCommandChangeUser
	instanceVariableNames: 'user password database charset scrambleBuff scrambledPassword'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandChangeUser guid: (GUID fromString: '{d87b04f7-c06b-4980-bda8-2ceecadf2380}')!

MySQLCommandChangeUser comment: 'MySQL command to change user'!

!MySQLCommandChangeUser categoriesForClass!MySQL-Core-Command! !

!MySQLCommandChangeUser methodsFor!

charset: cset 	charset := cset!

commandArg	| buffStream |	buffStream := WriteStream on: ByteArray new.	buffStream		nextPutAll: user asByteArray;		nextPut: 0.	MySQLPacket new		encodeLcs: scrambledPassword asByteArray		on: buffStream.	buffStream		nextPutAll:			(database ifNil: [ '' asByteArray ] ifNotNil: [ database asByteArray ]);		nextPut: 0.	buffStream		nextPut: (charset byteAt: 1);		nextPut: (charset byteAt: 2).	^ buffStream contents!

commandCode	^ ComChangeUser !

database: dbName	database := dbName!

password: pwd	password := pwd!

readResponse	| pkt |	pkt := super readResponse.	pkt isOkayOrError 		ifTrue: [^ pkt].			pkt isEof ifTrue: [		"Absorb the response"		session read.		"For old (short) hash style passwords"		self send323Scramble.		pkt := super readResponse.		pkt isOkayOrError 			ifTrue: [^ pkt]].			MySQLDriverError signal: 'Unrecognized response for command'	!

scrambleBuff: seed	scrambleBuff := seed	!

scrambledPassword: pwd	scrambledPassword := pwd	!

send323Scramble	| scrmblPkt |	scrmblPkt := MySQL323Scramble new.	scrmblPkt password: password; scrambleBuff: scrambleBuff.	self writePacket: scrmblPkt	!

user: userName	user := userName! !

!MySQLCommandChangeUser categoriesForMethods!
charset:!accessing!public! !
commandArg!defaults!public! !
commandCode!defaults!public! !
database:!accessing!public! !
password:!accessing!public! !
readResponse!operating!public! !
scrambleBuff:!public!scrambling! !
scrambledPassword:!public!scrambling! !
send323Scramble!public!scrambling! !
user:!accessing!public! !
!

