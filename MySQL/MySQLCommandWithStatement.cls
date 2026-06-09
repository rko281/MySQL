"Filed out from Dolphin Smalltalk"!

MySQLCommandWithResults subclass: #MySQLCommandWithStatement
	instanceVariableNames: 'stmtId mapResultsToNativeTypes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandWithStatement guid: (GUID fromString: '{ad4f1620-8eaf-4207-b0a7-5e679523061e}')!

MySQLCommandWithStatement comment: ''!

!MySQLCommandWithStatement categoriesForClass!MySQL-Core-Command! !

!MySQLCommandWithStatement methodsFor!

initialize	super initialize.	mapResultsToNativeTypes := true	!

mapResultsToNativeTypes: aBoolean	mapResultsToNativeTypes := aBoolean!

readOneRow: fields 
	^self rowClass new
		columnDescriptors: fields;
		read: session read;
		yourself!

readRowData: fields 
	| respRows row |
	respRows := OrderedCollection new.
	
	[self gotEof] whileFalse: [ 
		"Read each row and save it"
		row := self readOneRow: fields.
		respRows add: row].
		
	^ respRows asArray!

rowClass
	^mapResultsToNativeTypes 
		ifTrue: [ MySQLBinaryRowData ]
		ifFalse: [ MySQLStringRowData ]!

statementId: id
	stmtId := id! !

!MySQLCommandWithStatement categoriesForMethods!
initialize!initialization!public! !
mapResultsToNativeTypes:!accessing!public! !
readOneRow:!public!reading! !
readRowData:!public!reading! !
rowClass!accessing!public! !
statementId:!accessing!public! !
!

