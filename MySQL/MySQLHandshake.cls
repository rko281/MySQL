"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLHandshake
	instanceVariableNames: 'protocolVer serverVer threadId scrambleBuff serverCap serverLang scrambleBuffMore serverStatus pluginName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLHandshake guid: (GUID fromString: '{2ce84397-c60e-4f56-89dc-570d21be8aad}')!

MySQLHandshake comment: 'Handshake packet for MySQL'!

!MySQLHandshake categoriesForClass!MySQL-Core-Packet! !

!MySQLHandshake methodsFor!

clientAuth

	self supportsProtocol41 ifFalse: [MySQLUnsupportedProtocolError signal: 'Server does not support protocol version 41'].

	^(MySQLClientAuth forPluginName: pluginName)
		serverCaps: self serverCaps;
		charset: self serverLang;
		scrambleBuff: self scrambleBuff ;
		scrambleBuffMore: self scrambleBuffMore;
		yourself!

parse 
	protocolVer := inStream next.	serverVer := Utf8String fromByteArray: (inStream upTo: 0).	threadId := inStream next + (inStream next bitShift: 8) + 		(inStream next bitShift: 16) + (inStream next bitShift: 24).	scrambleBuff := inStream next: 8.	inStream skip: 1.	"always 0"	serverCap := inStream next + (inStream next bitShift: 8).	serverLang := inStream next.	serverStatus := inStream next + (inStream next bitShift: 8).
	serverCap := serverCap + (inStream next bitShift: 16) + (inStream next bitShift: 24). "Capability flags (upper 16 bits)"
	inStream next = 21 ifFalse: [self error: 'bad handshake'] . "Auth plugin data length = 21"	inStream skip: 10.	"filler"	self supportsProtocol41 ifFalse: [ ^ self ].	scrambleBuffMore := inStream next: 12.	inStream skip: 1.	"always 0"
	pluginName := AnsiString fromByteArray: (inStream upTo: 0)!

pluginName

	^pluginName!

pluginName: aString

	pluginName := aString!

scrambleBuff		^ scrambleBuff		"self supports41 		ifTrue: [^ scrambleBuff, scrambleBuffMore]		ifFalse: [^ scrambleBuff]."!

scrambleBuff: aByteArray		scrambleBuff := aByteArray.
	scrambleBuffMore := #[]!

scrambleBuffMore	^scrambleBuffMore !

serverCaps	^ serverCap!

serverLang	^ serverLang!

serverStatus	^ serverStatus!

serverVer	^ serverVer!

supportsProtocol41	^ (serverCap bitAnd: CapProtocol41) = CapProtocol41! !

!MySQLHandshake categoriesForMethods!
clientAuth!accessing!public! !
parse!parsing!public! !
pluginName!accessing!public! !
pluginName:!accessing!public! !
scrambleBuff!accessing!public! !
scrambleBuff:!accessing!public! !
scrambleBuffMore!public!scrambling! !
serverCaps!accessing!public! !
serverLang!accessing!public! !
serverStatus!accessing!public! !
serverVer!accessing!public! !
supportsProtocol41!public!testing! !
!

