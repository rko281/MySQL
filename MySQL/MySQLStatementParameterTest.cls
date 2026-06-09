"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLStatementParameterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLStatementParameterTest guid: (GUID fromString: '{b23f279d-d358-4d0c-9f64-d80980e94639}')!

MySQLStatementParameterTest comment: ''!

!MySQLStatementParameterTest categoriesForClass!MySQL-Core-Tests-Integration-Base! !

!MySQLStatementParameterTest methodsFor!

testParamNull	| inParam |	inParam := MySQLBindParameter new.	inParam bindValue: nil.	self assert: inParam isNull.! !

!MySQLStatementParameterTest categoriesForMethods!
testParamNull!public!tests! !
!

