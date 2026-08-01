"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLAuthSwitch
	instanceVariableNames: 'pluginName scrambleBuff password'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLAuthSwitch guid: (GUID fromString: '{0c8534a1-23f2-41c2-986f-46fcd96d3f61}')!

MySQLAuthSwitch comment: ''!

!MySQLAuthSwitch categoriesForClass!MySQL-Core-Packet! !

!MySQLAuthSwitch methodsFor!

isCachingSha2

	^pluginName = MySQLSha2ClientAuth pluginName!

isNativePassword

	^pluginName = MySQLClientAuth pluginName!

parse

	inStream next.
	pluginName := (inStream upTo: 0) asAnsiString.
	scrambleBuff := inStream upTo: 0!

password: pwd	password := pwd.!

pluginName

	^pluginName!

scramble

	^self isNativePassword 
		ifTrue: [MySQLHelper secureScramble: scrambleBuff with: password]
		ifFalse: [MySQLHelper secureScramble256: scrambleBuff with: password]!

scrambleBuff

	^scrambleBuff! !

!MySQLAuthSwitch categoriesForMethods!
isCachingSha2!public!testing! !
isNativePassword!public!testing! !
parse!parsing!public! !
password:!accessing!public! !
pluginName!accessing!public! !
scramble!public!scrambling! !
scrambleBuff!accessing!public! !
!

