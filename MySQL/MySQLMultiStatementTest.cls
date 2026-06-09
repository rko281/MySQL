"Filed out from Dolphin Smalltalk"!

MySQLTestCase subclass: #MySQLMultiStatementTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLMultiStatementTest guid: (GUID fromString: '{e4a21527-2e71-44c8-a2e5-3629664f7d81}')!

MySQLMultiStatementTest comment: 'Connection with mutistatement disabled- should return query statement error when multiple statements are sent in a queryConnection with multistatement enabled- should return an error if the first statement causes an error- should return okay or result sets for consecutive successful statements, followed by an error if an error occurs at a statement and no response for the rest of the statements after the one that caused error- should return okay or result sets for all statements if there is no error'!

!MySQLMultiStatementTest categoriesForClass!MySQL-Core-Tests-Integration-Base! !

!MySQLMultiStatementTest methodsFor!

testErrorAtEnd	| resp qString conn |	qString := 		'select * from nameValue where id=''1'';', "good"		'insert into nameValue (name, value) values(''name03'', ''value03'');', "good"		'select * from nameValue;', "good"		'select * from t2;'. "bad"	conn := self connection.	resp := conn query: qString.	self assert: (resp isResultSet and: [resp hasMoreResults]).	self assert: (resp nextResult isOkay and: [resp nextResult hasMoreResults]).	self assert: (resp nextResult nextResult isResultSet 		and: [resp nextResult nextResult hasMoreResults = true]).	self assert: (resp nextResult nextResult nextResult isError 		and: [resp nextResult nextResult nextResult hasMoreResults = false]).	!

testErrorAtFirst	| resp qString conn |		qString := 		'select * from t2;', "bad"		'select * from t1 where id=''1'';', "good"		'insert into t1 values(''name01'', ''value01'');', "good"		'select * from t1;'. "good"	conn := self connection.	resp := conn query: qString.	self assert: (resp isError and: [resp hasMoreResults not])	!

testErrorAtMiddle	| resp qString conn |	qString := 		'select * from nameValue where id=''1'';', "good"		'insert into nameValue (name, value) values(''name02'', ''value02'');', "good"		'select * from t2;', "bad"		'select * from nameValue;'. "good"	conn := self connection.	resp := conn query: qString.	self assert: (resp isResultSet and: [resp hasMoreResults]).	self assert: (resp nextResult isOkay and: [resp nextResult hasMoreResults]).	self assert: (resp nextResult nextResult isError 		and: [resp nextResult nextResult hasMoreResults = false]).!

testNoError	| resp qString conn |	qString := 		'select * from nameValue where id=''1'';', "good"		'insert into nameValue (name, value) values(''name04'', ''value04'');', "good"		'select * from nameValue;'. "good"	conn := self connection.	resp := conn query: qString.	self assert: (resp isResultSet and: [resp hasMoreResults]).	self assert: (resp nextResult isOkay and: [resp nextResult hasMoreResults]).	self assert: (resp nextResult nextResult isResultSet 		and: [resp nextResult nextResult hasMoreResults = false])	! !

!MySQLMultiStatementTest categoriesForMethods!
testErrorAtEnd!public!tests! !
testErrorAtFirst!public!tests! !
testErrorAtMiddle!public!tests! !
testNoError!public!tests! !
!

