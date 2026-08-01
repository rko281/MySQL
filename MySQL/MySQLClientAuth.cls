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

authHeader

	| buffStream |

	buffStream := (ByteArray new: 32) writeStream.
	self writeAuthHeaderOn: buffStream.
	^buffStream contents!

charset: csNum	charset := csNum!

database: db	database := db!

initialize	clientCaps := CapLongFlag + CapTransactions + CapLongPassword + CapConnectWithDb.	clientCaps := clientCaps + CapProtocol41 + CapSecureConnection.!

options: anInteger

	clientCaps := clientCaps bitOr: anInteger!

password: pwd	password := pwd.!

scramble

	^MySQLHelper secureScramble: scrambleBuff , scrambleBuffMore with: password !

scrambleBuff: buffer	scrambleBuff := buffer.!

scrambleBuffMore: more	scrambleBuffMore := more!

serverCaps: caps 	serverCaps := caps!

user: userName	user := userName!

write	| buffStream |
	buffStream := WriteStream on: (ByteArray new: 1024).
	self writeOn: buffStream.	^ buffStream contents!

writeAuthHeaderOn: buffStream	| flags maxNetPacketLength |		flags := serverCaps bitAnd: clientCaps.	flags := flags bitOr: CapMultiStatements + CapMultiResults.	buffStream		nextPut: (flags byteAt: 1);		nextPut: (flags byteAt: 2);		nextPut: (flags byteAt: 3);		nextPut: (flags byteAt: 4).	maxNetPacketLength := self class maxNetPacketLength.	buffStream		nextPut: (maxNetPacketLength byteAt: 1);		nextPut: (maxNetPacketLength byteAt: 2);		nextPut: (maxNetPacketLength byteAt: 3);		nextPut: (maxNetPacketLength byteAt: 4).	buffStream nextPut: (charset byteAt: 1).	buffStream nextPutAll: (ByteArray new: 23 withAll: 0)	"filler"!

writeOn: buffStream	
	self writeAuthHeaderOn: buffStream.
	buffStream nextPutAll: user asByteArray.	buffStream nextPut: 0.	"null terminated"		self encodeLcs: self scramble on: buffStream.	((serverCaps bitAnd: clientCaps) bitAnd: CapConnectWithDb) = CapConnectWithDb		ifTrue: [ (database ifNil: ['']) isEmpty ifFalse: [ buffStream nextPutAll: database asByteArray ].			buffStream nextPut: 0	"null terminated" ]! !

!MySQLClientAuth categoriesForMethods!
authHeader!public!writing! !
charset:!accessing!public! !
database:!accessing!public! !
initialize!initialization!public! !
options:!accessing!public! !
password:!accessing!public! !
scramble!public!scrambling! !
scrambleBuff:!public!scrambling! !
scrambleBuffMore:!public!scrambling! !
serverCaps:!accessing!public! !
user:!accessing!public! !
write!public!writing! !
writeAuthHeaderOn:!private!writing! !
writeOn:!private!writing! !
!

!MySQLClientAuth class methodsFor!

forPluginName: aString

	aString = self pluginName ifTrue: [^self new].

	^(self allSubclasses detect: [ :each | each pluginName = aString] ifNone: [MySQLUnsupportedProtocolError signal: 'unsupported plugin: ', aString]) new!

new

	^super new initialize!

pluginName

	^'mysql_native_password'! !

!MySQLClientAuth class categoriesForMethods!
forPluginName:!instance creation!public! !
new!instance creation!public! !
pluginName!constants!public! !
!

