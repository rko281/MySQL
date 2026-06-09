"Filed out from Dolphin Smalltalk"!

MySQLBinaryRowData subclass: #MySQLStringRowData
	instanceVariableNames: 'columnStrings'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLStringRowData guid: (GUID fromString: '{26432c5f-28e7-4fdb-b4a4-8f392654cf89}')!

MySQLStringRowData comment: 'String row data packet for MySQL'!

!MySQLStringRowData categoriesForClass!MySQL-Core-Packet-RowData! !

!MySQLStringRowData methodsFor!

atIndex: indx	^ columnStrings at: indx ifAbsent: [MySQLInvalidRowAccess signal: 'No data at this index']	!

parse	super parse.	columnStrings := columnValues collect: [:each | 		each ifNil: ['NULL'] ifNotNil: [			(each isKindOf: Date) ifTrue: [each yyyymmdd] ifFalse: [				(each isKindOf: Time) ifTrue: [each printStringFormat: 'HH:mm:ss'] ifFalse: [					(each isKindOf: DateAndTime) ifTrue: [each printStringFormat: 'yyyy\-MM\-dd\THH:mm:ss'] ifFalse: [
						(each isKindOf: Duration) ifTrue: [each printString] ifFalse: [							(each isKindOf: ByteArray) ifTrue: [Utf8String fromByteArray: each] ifFalse: [each displayString]]]]]]]	! !

!MySQLStringRowData categoriesForMethods!
atIndex:!accessing!public! !
parse!parsing!public! !
!

