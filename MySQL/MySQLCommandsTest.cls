"Filed out from Dolphin Smalltalk"!

MySQLTestCase subclass: #MySQLCommandsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandsTest guid: (GUID fromString: '{3d48f820-a9c8-4256-aabb-c6c54b095976}')!

MySQLCommandsTest comment: ''!

!MySQLCommandsTest categoriesForClass!MySQL-Core-Tests-Integration-Base! !

!MySQLCommandsTest methodsFor!

testChangeUser	| spec altSpec conn |	spec := self driverSpec.	spec db: nil.	altSpec := spec copy.	altSpec user: self class resourceClass alternativeUsername.	conn := self connection.		self assert: (conn changeUser: altSpec) isOkay.	self assert: (conn changeUser: spec) isOkay.	self assert: (conn changeUser: altSpec) isOkay.	self assert: (conn changeUser: spec) isOkay.	conn disconnect.	self should: [conn changeUser: spec] raise: MySQLNoConnectionError. !

testChangeUserOnUnsecuredConnection

	"Test connecting as a user who requires caching_sha2_password authentication fails on an unsecured connection"

	self _createNativePasswordUser: 
		[ :nativeConnectionSpec || connection |
		nativeConnectionSpec useUnsecuredConnection.
		connection := MySQLDriver new.
		connection connect: nativeConnectionSpec.
		self _createCachingSha2User: 
			[ :connectionSpec |
			self should: [connection changeUser: connectionSpec] raise: MySQLUnsupportedProtocolError]]!

testDescribeTable	| results |	results := self connection query: 'describe nameValue'.	self assert: (results rows size = 3).!

testPing	| conn |	conn := self connection.	self assert: conn ping isOkay.	conn disconnect.	self should: [conn ping] raise: MySQLNoConnectionError !

testStmtClose	| resp paramList prepResp conn stmt |	conn := self connection.	conn query: 'insert into mix values(''key01'', ''111222333444.555666777'')'.	conn query: 'insert into mix values(''key02'', NULL)'.	prepResp := conn prepare: 'select * from mix where name = ?'.	stmt := MySQLDriverStatement onConnection: conn.	paramList := Array with: (MySQLBindParameter new bindValue: 'key01').	stmt stmtId: prepResp prepareOkay stmtHandlerId; params: paramList.		stmt close. "will try to use after close"	resp := [stmt execute] on: MySQLDriverError do: [ :exc | exc return: exc response].			self assert: resp isError.	self assert: (resp sqlState = 'HY000').	self assert: (resp errNo = 1243).	!

testStmtExecute	| resp paramList prepResp conn stmt |	conn := self connection.	conn query: 'insert into mix values(''key01'', ''111222333444.555666777'')'.	conn query: 'insert into mix values(''key02'', NULL)'.	prepResp := conn prepare: 'select * from mix where name = ?'.	stmt := MySQLDriverStatement onConnection: conn.	paramList := Array with: (MySQLBindParameter new bindValue: 'key01').	stmt		stmtId: prepResp prepareOkay stmtHandlerId;		params: paramList.	resp := stmt execute.	self assert: resp isResultSet.	self assert: resp rows size = 1.	self assert: (resp rows first atIndex: 1) = 'key01'.	self assert: (resp rows first atIndex: 2) = 111222333444.555666777s9.	paramList :=  Array with: (MySQLBindParameter new bindValue: 'key02').	stmt params: paramList.	resp := 	stmt execute.	self assert: resp isResultSet.	self assert: resp rows size = 1.	self assert: (resp rows first atIndex: 1) = 'key02'.	self assert: (resp rows first atIndex: 2) isNil	!

testStmtPrepare	| resp conn |	conn := self connection.	resp := conn query: 'insert into nameValue values(''1'', ''key01'', ''value01'')'.	self assert: resp isOkay.	self assert: resp affectedRows = 1.	resp := conn query: 'insert into nameValue values					(''2'', ''key02'', ''value02''), 					(''3'', ''key03'', ''value03'')'.	self assert: resp isOkay.	self assert: resp affectedRows = 2.	resp := conn prepare: 'select * from nameValue where name = ?'.	self assert: resp isPrepareResponse.	self assert: resp prepareOkay warningCount = 0.	self assert: resp prepareOkay numParams = 1.	self assert: (resp paramDescriptors first) name = '?'.	self assert: resp prepareOkay numColumns = 3.	self assert: (resp columnDescriptors first) name = 'id'.	self assert: (resp columnDescriptors at: 2) name = 'name'.	self assert: (resp columnDescriptors at: 3) name = 'value'! !

!MySQLCommandsTest categoriesForMethods!
testChangeUser!public!tests! !
testChangeUserOnUnsecuredConnection!public!tests! !
testDescribeTable!public!tests! !
testPing!public!tests! !
testStmtClose!public!tests! !
testStmtExecute!public!tests! !
testStmtPrepare!public!tests! !
!

