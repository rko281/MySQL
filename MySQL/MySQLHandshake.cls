"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLHandshake
	instanceVariableNames: 'protocolVer serverVer threadId scrambleBuff serverCap serverLang scrambleBuffMore serverStatus'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLHandshake guid: (GUID fromString: '{2ce84397-c60e-4f56-89dc-570d21be8aad}')!

MySQLHandshake comment: 'Handshake packet for MySQL'!

!MySQLHandshake categoriesForClass!MySQL-Core-Packet! !

!MySQLHandshake methodsFor!

parse 	protocolVer := inStream next.	serverVer := Utf8String fromByteArray: (inStream upTo: 0).	threadId := inStream next + (inStream next bitShift: 8) + 		(inStream next bitShift: 16) + (inStream next bitShift: 24).	scrambleBuff := inStream next: 8.	inStream skip: 1.	"always 0"	serverCap := inStream next + (inStream next bitShift: 8).	serverLang := inStream next.	serverStatus := inStream next + (inStream next bitShift: 8).	inStream skip: 13.	"filler"	self supportsProtocol41 ifFalse: [ ^ self ].	scrambleBuffMore := inStream next: 12.	inStream skip: 1	"always 0"!

scrambleBuff		^ scrambleBuff		"self supports41 		ifTrue: [^ scrambleBuff, scrambleBuffMore]		ifFalse: [^ scrambleBuff]."!

scrambleBuffMore	^scrambleBuffMore !

serverCaps	^ serverCap!

serverLang	^ serverLang!

serverStatus	^ serverStatus!

serverVer	^ serverVer!

supportsProtocol41	^ (serverCap bitAnd: CapProtocol41) = CapProtocol41! !

!MySQLHandshake categoriesForMethods!
parse!parsing!public! !
scrambleBuff!accessing!public! !
scrambleBuffMore!public!scrambling! !
serverCaps!accessing!public! !
serverLang!accessing!public! !
serverStatus!accessing!public! !
serverVer!accessing!public! !
supportsProtocol41!public!testing! !
!

