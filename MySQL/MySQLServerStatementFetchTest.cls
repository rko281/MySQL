"Filed out from Dolphin Smalltalk"!

MySQLTestCase subclass: #MySQLServerStatementFetchTest
	instanceVariableNames: 'stmt'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLServerStatementFetchTest guid: (GUID fromString: '{bc24066c-536d-4640-a8f8-274cef37413f}')!

MySQLServerStatementFetchTest comment: ''!

!MySQLServerStatementFetchTest categoriesForClass!MySQL-Core-Tests-Integration-Base! !

!MySQLServerStatementFetchTest methodsFor!

scenarios^ '- should read zero rows- should read one row- should read some rows- should read all rows in batches '!

setUp	|  stmtId resp |	super setUp.		self withFixtures: #(#zero) do: [:conn | 		resp := conn prepare: 			'select name, value, entryOn, notes from testMisc 			where entryOn < ?'.		stmtId := resp prepareOkay stmtHandlerId.		stmt := MySQLDriverStatement onConnection: conn.		stmt stmtId: stmtId; cursoredFetch: true]	!

tearDown	stmt close.	super tearDown.	!

testDoesntNeedResetOnCompleteRead

	"Test that a statement is not set to needsReset when a result set is completely read (not streamed)"
	| resp |	
	stmt 
		params: {MySQLBindParameter withValue: '2011-09-01'};
		cursoredFetch: false.
	resp := stmt execute.
	self assert: resp isResultSet.
	self assert: resp rows size equals: 10.	self deny: stmt needsReset	!

testNeedsResetOnError

	"Test that a statement is set to needsReset if it is subject to an error"

	| resp |
	resp := [stmt execute] on: MySQLDriverError do: [ :exc | exc return: exc response].
	self assert: resp isError.	self assert: stmt needsReset.
!

testNeedsResetOnIncompleteRead

	"Test that a statement is set to needsReset if a result set is not completely read"

	| resp |

	stmt 
		params: {MySQLBindParameter withValue: '2011-09-01'};
		fetchSize: 2.
	resp := stmt execute.
	self assert: resp isResultSet.	self assert: stmt needsReset.

	resp next.
	self assert: stmt needsReset.

	"Once all rows read the statement no longer needsReset"
	[resp atEnd] whileFalse: [resp next].
	self deny: stmt needsReset	!

testNeedsResetWithLongParams

	"Test that a statement is set to needsReset if used with long data parameters" 
	| conn prep stmtId longText resp |	conn := self connection.
	prep := conn prepare: 'insert into testTexts (id,longtextvalue) values(?,?)'.
	stmtId := prep prepareOkay stmtHandlerId.

	stmt := MySQLDriverStatement onConnection: conn.
	stmt stmtId: stmtId.

	"Long data threshold is 1MB"
	longText := (String new: (1024*1024) + 1) atAllPut: $x; yourself.
	stmt params: ({1. longText} collect: [ :each | MySQLBindParameter new bindValue: each]).
	resp := stmt execute.	self assert: resp isOkay.
	self assert: stmt needsReset.

	stmt params: (#(2 'abc') collect: [ :each | MySQLBindParameter new bindValue: each]).
	resp := stmt execute.
	self assert: resp isOkay.
	self deny: stmt needsReset.

	"Validate inserted values"
	resp := conn query: 'select * from testTexts order by id'.
	self assert: (resp rows first at: 'id') equals: 1.
	self assert: (resp rows first at: 'longtextValue') equals: longText.
	self assert: (resp rows second at: 'id') equals: 2.
	self assert: (resp rows second at: 'longtextValue') equals: 'abc'!

testReadAllRowsAtATime	| rs rd |	stmt params: (Array with: (MySQLBindParameter withValue: '2011-09-01')) .	rs := stmt execute.	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.	rd := stmt fetchRows: 1000.	self assert: rd rows size = 10; assert: rs hasOpenCursor; assert: rd hasLastRowSent.	rd := stmt fetchRows: 1.	self assert: rd isError	!

testReadNextRowFetchAll		"Test nextRow where fetch size is greater than data size"	| rs rd |		stmt fetchSize: 100.	stmt params: (Array with:  (MySQLBindParameter withValue: '2011-09-01')).	rs := stmt execute.	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.	10 timesRepeat:		[ rd := rs nextRow.		self deny: rd isNil ].		self assert: rs atEnd.	rd := rs nextRow.	self 		assert: rd isNil; 		assert: rs atEnd!

testReadNextRowFetchExact		"Test nextRow where fetch size is same as data size"		| rs rd |		stmt fetchSize: 10.	stmt params: (Array with:  (MySQLBindParameter withValue: '2011-09-01')).	rs := stmt execute.	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.	10 timesRepeat:		[ rd := rs nextRow.		self deny: rd isNil ].		self assert: rs atEnd.	rd := rs nextRow.	self 		assert: rd isNil; 		assert: rs atEnd!

testReadNextRowFetchIncremental		"Test nextRow where incremental fetches are needed"		| rs rd |		stmt fetchSize: 2.	stmt params: (Array with:  (MySQLBindParameter withValue: '2011-09-01')).	rs := stmt execute.	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.	10 timesRepeat:		[ rd := rs nextRow.		self deny: rd isNil ].		self assert: rs atEnd.	rd := rs nextRow.	self 		assert: rd isNil; 		assert: rs atEnd!

testReadOneRowAtATime	| rs rd |	stmt params: (Array with:  (MySQLBindParameter withValue: '2011-09-01')).	rs := stmt execute.	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.	10 timesRepeat: [		rd := stmt fetchRows: 1.		self assert: rd rows size = 1; deny: rd hasLastRowSent].	rd := stmt fetchRows: 1.	self 		assert: rd rows isEmpty; 		assert: rd hasLastRowSent.	!

testReadSomeRowsAtATime	| rs rd |	stmt params: (Array with: (MySQLBindParameter withValue: '2011-09-01')).	rs := stmt execute.	self assert: rs isResultSet; assert: rs hasOpenCursor; deny: rs hasLastRowSent.	3 timesRepeat: [		rd := stmt fetchRows: 3.		self assert: rd rows size = 3; deny: rd hasLastRowSent].	rd := stmt fetchRows: 3.	self assert: rd rows size = 1; assert: rd hasLastRowSent.		! !

!MySQLServerStatementFetchTest categoriesForMethods!
scenarios!accessing!public! !
setUp!public!running! !
tearDown!public!running! !
testDoesntNeedResetOnCompleteRead!public!tests! !
testNeedsResetOnError!public!tests! !
testNeedsResetOnIncompleteRead!public!tests! !
testNeedsResetWithLongParams!public!tests! !
testReadAllRowsAtATime!public!tests! !
testReadNextRowFetchAll!public!tests! !
testReadNextRowFetchExact!public!tests! !
testReadNextRowFetchIncremental!public!tests! !
testReadOneRowAtATime!public!tests! !
testReadSomeRowsAtATime!public!tests! !
!

