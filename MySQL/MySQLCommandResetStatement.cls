"Filed out from Dolphin Smalltalk"!

MySQLCommandBase subclass: #MySQLCommandResetStatement
	instanceVariableNames: 'statementId'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandResetStatement guid: (GUID fromString: '{dd0474e2-e0cd-4e2b-8636-198beabd18b6}')!

MySQLCommandResetStatement comment: 'MySQL reset statement command'!

!MySQLCommandResetStatement categoriesForClass!MySQL-Core-Command! !

!MySQLCommandResetStatement methodsFor!

commandArg	^ByteArray		streamContents: [ :strm | 			strm				nextPut: (statementId byteAt: 1);				nextPut: (statementId byteAt: 2);				nextPut: (statementId byteAt: 3);				nextPut: (statementId byteAt: 4) ]!

commandCode	^ ComStmtReset 	!

readResponse	| pkt |	pkt := super readResponse.	pkt isOkayOrError 		ifTrue: [^ pkt] 		ifFalse: [self error: 'Unrecognized response for command']		!

statementId: idValue "4 byte integer"	statementId := idValue		! !

!MySQLCommandResetStatement categoriesForMethods!
commandArg!defaults!public! !
commandCode!defaults!public! !
readResponse!public!reading! !
statementId:!accessing!public! !
!

