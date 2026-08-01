"Filed out from Dolphin Smalltalk"!

MySQLCommandBase subclass: #MySQLCommandChangeUser
	instanceVariableNames: 'connSpec driver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandChangeUser guid: (GUID fromString: '{d87b04f7-c06b-4980-bda8-2ceecadf2380}')!

MySQLCommandChangeUser comment: 'MySQL command to change user'!

!MySQLCommandChangeUser categoriesForClass!MySQL-Core-Command! !

!MySQLCommandChangeUser methodsFor!

commandArg
	| buffStream scrambledPassword charset |
	buffStream := WriteStream on: ByteArray new.
	scrambledPassword := (driver handshakeInfo clientAuth password: connSpec password; yourself) scramble.
	charset := driver handshakeInfo serverLang.

	buffStream		nextPutAll: connSpec user asByteArray; nextPut: 0; 
		nextPut: scrambledPassword size; nextPutAll: scrambledPassword;		nextPutAll: (connSpec db ifNil: [ #[] ] ifNotNil: [ :database | database asByteArray ]);		nextPut: 0;		nextPut: (charset byteAt: 1); nextPut: (charset byteAt: 2); 
		nextPutAll: driver handshakeInfo pluginName asByteArray; nextPut: 0.
	^ buffStream contents!

commandCode	^ ComChangeUser !

connSpec: aMySQLDriverSpec

	connSpec := aMySQLDriverSpec!

driver: aMySQLDriver

	driver := aMySQLDriver!

readResponse
	| pkt response |	pkt := super readResponse.

	pkt isAuthSwitch ifTrue: 
		[response := driver handleAuthSwitch: connSpec handshake: driver handshakeInfo.
		response isOkay 
		ifTrue: 
			[pkt := MySQLOkay from: session read]
		ifFalse: 
			[response isAuthMoreData ifFalse: [MySQLDriverError signal: 'Unrecognized response for command'].
			(driver handleAuthMoreData: connSpec) isOkay 
				ifTrue: [pkt := MySQLOkay from: session read]
				ifFalse: [pkt := MySQLError from: session read]]].
	pkt isOkayOrError ifTrue: [^ pkt].	"Absorb the response"	session read.	MySQLDriverError signal: 'Unrecognized response for command'	! !

!MySQLCommandChangeUser categoriesForMethods!
commandArg!defaults!public! !
commandCode!defaults!public! !
connSpec:!accessing!public! !
driver:!accessing!public! !
readResponse!operating!public! !
!

!MySQLCommandChangeUser class methodsFor!

forDriver: aMySQLDriver connSpec: aMySQLDriverSpec

	^(self onSession: aMySQLDriver netSession)
		driver: aMySQLDriver;
		connSpec: aMySQLDriverSpec;
		yourself! !

!MySQLCommandChangeUser class categoriesForMethods!
forDriver:connSpec:!accessing!instance creation!public! !
!

