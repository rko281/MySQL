"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLRowData
	instanceVariableNames: 'columnValues'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLRowData guid: (GUID fromString: '{78145e71-9847-4bc6-8d53-f5c2a6ab608f}')!

MySQLRowData comment: 'Common superclass for MySQL row data'!

!MySQLRowData categoriesForClass!MySQL-Core-Packet-RowData! !

!MySQLRowData methodsFor!

at: index		^ self atIndex: index!

atIndex: indx	^ columnValues at: indx ifAbsent: [MySQLInvalidRowAccess signal: 'No data at this index']	!

do: aBlock 	^columnValues do: aBlock!

eighth  	^self atIndex: 8!

fifth 	^self atIndex: 5!

first 	^self atIndex: 1!

fourth 	^self atIndex: 4!

last	^self atIndex: columnValues size!

ninth  	^self atIndex: 9!

parse	self subclassResponsibility 	!

second 	^self atIndex: 2!

seventh 	^self atIndex: 7!

sixth 	^self atIndex: 6!

tenth  	^self atIndex: 10!

third 	^self atIndex: 3! !

!MySQLRowData categoriesForMethods!
at:!accessing!public! !
atIndex:!accessing!public! !
do:!enumerating!public! !
eighth!accessing!public! !
fifth!accessing!public! !
first!accessing!public! !
fourth!accessing!public! !
last!accessing!public!reading! !
ninth!accessing!public! !
parse!parsing!public! !
second!accessing!public! !
seventh!accessing!public! !
sixth!accessing!public! !
tenth!accessing!public! !
third!accessing!public! !
!

