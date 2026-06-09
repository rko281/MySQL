"Filed out from Dolphin Smalltalk"!

MySQLCommandWithStatement subclass: #MySQLCommandExecute
	instanceVariableNames: 'params cursoredFetch'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandExecute guid: (GUID fromString: '{72d66eb8-73e3-41ae-9773-ae6bc2aa1a53}')!

MySQLCommandExecute comment: 'MySQL command to execute'!

!MySQLCommandExecute categoriesForClass!MySQL-Core-Command! !

!MySQLCommandExecute methodsFor!

commandArg	^ByteArray		streamContents: [ :strm || nonLongs |			strm				nextPut: (stmtId byteAt: 1);				nextPut: (stmtId byteAt: 2);				nextPut: (stmtId byteAt: 3);				nextPut: (stmtId byteAt: 4).			cursoredFetch				ifTrue: [ strm nextPut: 1	"flags => READ_CURSOR" ]				ifFalse: [ strm nextPut: 0	"flags => NO_CURSOR" ].			strm				nextPut: 1;				nextPut: 0;				nextPut: 0;				nextPut: 0.	"iterationCount"			strm nextPutAll: self nullBitMap.			self hasNewParamBound				ifTrue: [ strm nextPut: 1.	"new params bound <- true"					params						do: [ :each | | paramType |							paramType := each paramType.							strm								nextPut: (paramType byteAt: 1);								nextPut: (paramType byteAt: 2) ] ]				ifFalse: [ strm nextPut: 0 ].	"new params bound <- false"			nonLongs := params				ifNil: [ #() ]				ifNotNil: [ params reject: [ :each | each isLongData ] ].			nonLongs do: [ :each | each storeBinaryOn: strm ] ]!

commandCode	^ ComStmtExecute 	!

cursoredFetch: aBoolean 	cursoredFetch := aBoolean	!

execute	| resp |	"Remember to send long data for the longdata params before calling here"	resp := super execute.	self resetNewParamBound.	^ resp	!

hasNewParamBound	^ params anySatisfy: [:each | each isRebound]	!

initialize	super initialize.	cursoredFetch := false!

nullBitMap	| nullBitMap |	nullBitMap := ByteArray new: (params size + 7) // 8.	params keysAndValuesDo: [:paramIndex :each || mapByte byteIndex bitMask |		each isNull ifTrue: [			byteIndex := (paramIndex + 7) // 8.			bitMask := 1 bitShift: (paramIndex + 7) \\ 8.			mapByte := nullBitMap at: byteIndex.			mapByte := mapByte bitOr: bitMask.			nullBitMap at: byteIndex put: mapByte.		]	].	^ nullBitMap 	!

params: inParams	params := inParams	!

readFields	| respFields field |	respFields := OrderedCollection new.		[self gotEof] whileFalse:[ 		"Read each field and save it"		field := self readOneField.		respFields add: field ].			^ respFields asArray			!

readOneField	^ MySQLField from: session read.!

readResponse	| resp |	resp := self readResult.	"We do not need to look for multi-result responses in statement execute; so the following	line of code is commented out. Check COM_QUERY response handling for multi-result"	"resp hasMoreResults ifTrue: [resp next: self readResponse]."	^ resp	!

readResult	| resultSetHdr pkt fieldsEof rows fields rowsEof |	pkt := super readResponse.	pkt isOkayOrError ifTrue: [^ pkt].		resultSetHdr := MySQLResultSetHeader from: session read.	fields := self readFields.	fieldsEof := self readEof.	"eof"	fieldsEof hasOpenCursor ifFalse: [			rows := self readRowData: fields.		rowsEof := self readEof. "eof"].		^self resultSetClass new		header: resultSetHdr;		fields: fields;		fieldsEof: fieldsEof;		rows: rows;		rowsEof: rowsEof;		yourself!

resetNewParamBound	params do: [:each | each resetReboundFlag]	!

resultSetClass

	^MySQLResultSet! !

!MySQLCommandExecute categoriesForMethods!
commandArg!defaults!public! !
commandCode!defaults!public! !
cursoredFetch:!accessing!public! !
execute!operating!public! !
hasNewParamBound!public!testing! !
initialize!initialization!public! !
nullBitMap!private / accessing!public! !
params:!accessing!public! !
readFields!public!reading! !
readOneField!public!reading! !
readResponse!public!reading! !
readResult!public!reading! !
resetNewParamBound!operating!public! !
resultSetClass!accessing!public! !
!

