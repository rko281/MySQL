"Filed out from Dolphin Smalltalk"!

MySQLCommandBase subclass: #MySQLCommandWithResults
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandWithResults guid: (GUID fromString: '{2b33dd0f-fccb-4ef0-8998-d121e6e18f65}')!

MySQLCommandWithResults comment: ''!

!MySQLCommandWithResults categoriesForClass!MySQL-Core-Command! !

!MySQLCommandWithResults methodsFor!

gotEof	^(MySQLPacket from: session peek) isEof 	!

readEof	^ MySQLEof from: session read	! !

!MySQLCommandWithResults categoriesForMethods!
gotEof!public!testing! !
readEof!public!reading! !
!

