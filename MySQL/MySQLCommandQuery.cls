"Filed out from Dolphin Smalltalk"!

MySQLCommandWithQuery subclass: #MySQLCommandQuery
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandQuery guid: (GUID fromString: '{6afd6bef-5485-422b-89d3-a30c1cf181b1}')!

MySQLCommandQuery comment: 'MySQL query command'!

!MySQLCommandQuery categoriesForClass!MySQL-Core-Command! !

!MySQLCommandQuery methodsFor!

commandCode	^ ComQuery !

readFields	| respFields field |	respFields := OrderedCollection new.		[self gotEof] whileFalse:[ 		"Read each field and save it"		field := self readOneField.		respFields add: field ].			^ respFields asArray	!

readOneField	^ MySQLField from: session read	!

readOneRow: fieldCount	| row |	row := MySQLQueryRowData new.	row columnCount: fieldCount.	row read: session read.	^ row	!

readOneRow: fieldCount fields: fields	| row |	row := MySQLQueryRowData new fields: fields; yourself.	row columnCount: fieldCount.	row read: session read.	^ row	!

readResponse	| resp |	resp := self readResult.	resp hasMoreResults ifTrue: [resp nextResult: self readResponse].	^ resp!

readResult	| fields fieldsEof rows rowsEof resultSetHdr pkt |	pkt := super readResponse.	pkt isOkayOrError 		ifTrue: [ ^ pkt ]		ifFalse: [ resultSetHdr := self readRsHeader ].	fields := self readFields.	fieldsEof := self readEof.	rows := self readRowData: resultSetHdr fieldCount fields: fields.	rowsEof := self readEof.	^ self resultSetClass new		header: resultSetHdr;		fields: fields;		fieldsEof: fieldsEof;		rows: rows;		rowsEof: rowsEof;		yourself!

readRowData: fieldCount 	| respRows row |	respRows := OrderedCollection new.		[self gotEof] whileFalse: [ 		"Read each field and save it"		row := self readOneRow: fieldCount.		respRows add: row].			^ respRows asArray	!

readRowData: fieldCount fields: fields	| respRows row |	respRows := OrderedCollection new.	[self gotEof] whileFalse: [ 		"Read each field and save it"		row := self readOneRow: fieldCount fields: fields.		respRows add: row].			^ respRows asArray	!

readRsHeader	^ MySQLResultSetHeader from: session read	!

resultSetClass

	^MySQLResultSet! !

!MySQLCommandQuery categoriesForMethods!
commandCode!defaults!public! !
readFields!public!reading! !
readOneField!public!reading! !
readOneRow:!public!reading! !
readOneRow:fields:!public!reading! !
readResponse!public!reading! !
readResult!public!reading! !
readRowData:!public!reading! !
readRowData:fields:!public!reading! !
readRsHeader!public!reading! !
resultSetClass!accessing!public! !
!

