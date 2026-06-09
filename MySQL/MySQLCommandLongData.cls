"Filed out from Dolphin Smalltalk"!

MySQLCommandBase subclass: #MySQLCommandLongData
	instanceVariableNames: 'dataBytes statementId paramNum'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandLongData guid: (GUID fromString: '{80df8f04-6cfc-4bcf-80e3-495a94599295}')!

MySQLCommandLongData comment: 'MySQL command for long datas'!

!MySQLCommandLongData categoriesForClass!MySQL-Core-Command! !

!MySQLCommandLongData methodsFor!

commandArg	^ByteArray		streamContents: [ :strm | 			strm				nextPut: (statementId byteAt: 1);				nextPut: (statementId byteAt: 2);				nextPut: (statementId byteAt: 3);				nextPut: (statementId byteAt: 4).			strm				nextPut: (paramNum byteAt: 1);				nextPut: (paramNum byteAt: 2).			strm nextPutAll: dataBytes ]!

commandCode	^ ComStmtSendLongData 	!

dataBytes: aByteArray	dataBytes := aByteArray 	!

paramNum: aNumber	paramNum := aNumber	!

readResponse	"This command does not have any response from server"	^ nil	!

statementId: anId	statementId := anId	! !

!MySQLCommandLongData categoriesForMethods!
commandArg!defaults!public! !
commandCode!defaults!public! !
dataBytes:!accessing!public! !
paramNum:!accessing!public! !
readResponse!public!reading! !
statementId:!accessing!public! !
!

