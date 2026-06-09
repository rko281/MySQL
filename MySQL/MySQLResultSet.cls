"Filed out from Dolphin Smalltalk"!

MySQLComplexResult subclass: #MySQLResultSet
	instanceVariableNames: 'header fields fieldsEof rows rowsEof rowsStream statement'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLResultSet guid: (GUID fromString: '{1402af39-e5b0-477a-97ea-3fad08dbd1f6}')!

MySQLResultSet comment: 'I am a simple facade on result set packets, although I behave as a MysqlPacketData. I don''t perform a read or write; my clients compose me from specific rasult set packets. I am designed this way to facilitate use of similar metaphors at the connector protocol level. I also behave a multi-result type of packet.'!

!MySQLResultSet categoriesForClass!MySQL-Core-Packet-Results! !

!MySQLResultSet methodsFor!

asJSON	^STON fromString: (self rows collect: [ :ea | ea asDictionary ])!

atEnd

	(rows isNil or: [self rowsStream atEnd]) ifTrue: [statement fetchRows].
	^self rowsStream atEnd!

fields	^ fields !

fields: flds	fields := flds!

fieldsEof	^ fieldsEof !

fieldsEof: eofPkt 	fieldsEof := eofPkt!

hasLastRowSent	"This is signaled during cursor based fetch for the rows. Therefore we	check for the singal in the eof field following the rows in the response."	^ rowsEof ifNil: [false] ifNotNil: [rowsEof hasLastRowSent]	!

hasMoreResults	"Looks like the flag, when set, will be set by the server in both the	field eof and rowdata eof packets. We are only using field eof here, since	rowdata eof may not sometimes sent as part of the result set (e.g., cursor)."	^ fieldsEof hasMoreResults	!

hasOpenCursor	^ fieldsEof hasOpenCursor 	!

header	^ header!

header: hdr	header := hdr!

isResultSet	^ true!

next	"Stream/cursored behaviour"		^self nextRow!

nextRow			^self atEnd 
		ifTrue: [nil]
		ifFalse: [self rowsStream nextAvailable]!

parse	self shouldNotImplement	!

rows	^ rows!

rows: allRows	rows := allRows.	rowsStream := nil!

rowsEof	^ rowsEof !

rowsEof: eofPkt	rowsEof := eofPkt.

	(statement notNil and: [statement needsReset and: [rowsEof hasLastRowSent]]) ifTrue: [statement needsReset: false]!

rowsStream	^rowsStream ifNil: [ rowsStream := ReadStream on: self rows ]!

serverStatus	^ fieldsEof serverStatus	!

statement: aStatement 		statement := aStatement! !

!MySQLResultSet categoriesForMethods!
asJSON!converting!public! !
atEnd!public!testing! !
fields!accessing!public! !
fields:!accessing!public! !
fieldsEof!accessing!public! !
fieldsEof:!accessing!public! !
hasLastRowSent!public!testing! !
hasMoreResults!public!testing! !
hasOpenCursor!public!testing! !
header!accessing!public! !
header:!accessing!public! !
isResultSet!public!testing! !
next!public!testing! !
nextRow!cursor!public! !
parse!parsing!public! !
rows!accessing!public! !
rows:!accessing!public! !
rowsEof!accessing!public! !
rowsEof:!accessing!public! !
rowsStream!accessing!public! !
serverStatus!accessing!public! !
statement:!accessing!public! !
!

