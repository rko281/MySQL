"Filed out from Dolphin Smalltalk"!

MySQLCommandBase subclass: #MySQLCommandCloseStatement
	instanceVariableNames: 'statementId'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandCloseStatement guid: (GUID fromString: '{f4092d0d-96c8-4ee6-ada3-be4bb3bd4f81}')!

MySQLCommandCloseStatement comment: 'MySQL command to close statement'!

!MySQLCommandCloseStatement categoriesForClass!MySQL-Core-Command! !

!MySQLCommandCloseStatement methodsFor!

commandArg	^ByteArray		streamContents: [ :strm | 			strm				nextPut: (statementId byteAt: 1);				nextPut: (statementId byteAt: 2);				nextPut: (statementId byteAt: 3);				nextPut: (statementId byteAt: 4) ]!

commandCode	^ ComStmtClose	!

readResponse	^ nil	!

statementId: idValue 	"4 byte integer"	statementId := idValue		! !

!MySQLCommandCloseStatement categoriesForMethods!
commandArg!defaults!public! !
commandCode!defaults!public! !
readResponse!operating!public! !
statementId:!accessing!public! !
!

