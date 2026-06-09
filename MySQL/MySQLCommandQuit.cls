"Filed out from Dolphin Smalltalk"!

MySQLCommandBase subclass: #MySQLCommandQuit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandQuit guid: (GUID fromString: '{2855f678-b186-475d-8c78-ff51d5d88aff}')!

MySQLCommandQuit comment: 'MySQL quit command'!

!MySQLCommandQuit categoriesForClass!MySQL-Core-Command! !

!MySQLCommandQuit methodsFor!

commandArg	^ nil!

commandCode	^ ComQuit !

readResponse	^ nil		! !

!MySQLCommandQuit categoriesForMethods!
commandArg!defaults!public! !
commandCode!defaults!public! !
readResponse!public!reading! !
!

