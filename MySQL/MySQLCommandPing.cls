"Filed out from Dolphin Smalltalk"!

MySQLCommandBase subclass: #MySQLCommandPing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandPing guid: (GUID fromString: '{0e046e95-3081-4d77-8e0d-4ff30f22b594}')!

MySQLCommandPing comment: 'MySQL ping command'!

!MySQLCommandPing categoriesForClass!MySQL-Core-Command! !

!MySQLCommandPing methodsFor!

commandArg	^ nil!

commandCode	^ ComPing !

readResponse	| pkt |	pkt := super readResponse.	pkt isOkayOrError 		ifTrue: [^ pkt] 		ifFalse: [self error: 'Unrecognized response for command']		! !

!MySQLCommandPing categoriesForMethods!
commandArg!defaults!public! !
commandCode!defaults!public! !
readResponse!public!reading! !
!

