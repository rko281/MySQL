"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLTestCase
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLTestCase guid: (GUID fromString: '{db3d0787-590e-4026-a247-03c1c5e0e997}')!

MySQLTestCase comment: ''!

!MySQLTestCase categoriesForClass!MySQL-Core-Tests-Integration-Base! !

!MySQLTestCase methodsFor!

cleanUpFixtureData	self class resourceClass current clearTestTables 	!

configureNotStrict: connection	"Change the sql_mode for the current session test (in case of strict mode enabled)"		connection query: 'SET SESSION sql_mode = ''NO_ENGINE_SUBSTITUTION'';'.!

connection	^ self testConnection	!

driverSpec	^ self class resourceClass driverSpecWithDb	!

loadOneFixture: fixtureName	| fixtureSel fixtureStmtList conn resp |	fixtureSel := 'fixture', fixtureName capitalized.	fixtureStmtList := self class fixtureClass perform: fixtureSel asSymbol.	fixtureStmtList do: [:stmt |		conn := self resourceConnection.		resp := conn query: stmt.		resp isError 			ifTrue: [self error: 'Error loading fixture from ', fixtureSel]]	!

resourceConnection	^ self class resourceClass current resourceConnection 	!

specForTest	^ self class resourceClass current specForTest!

tearDown	self cleanUpFixtureData.	super tearDown	!

testConnection	^ self class resourceClass current testConnection	!

withFixtures: fixtureNameList do: testBlock	fixtureNameList do: [:each | self loadOneFixture: each].	testBlock value: self resourceConnection 	! !

!MySQLTestCase categoriesForMethods!
cleanUpFixtureData!cleanup!public! !
configureNotStrict:!accessing!public! !
connection!accessing!public! !
driverSpec!accessing!public! !
loadOneFixture:!accessing!public! !
resourceConnection!accessing!public! !
specForTest!accessing!public! !
tearDown!public!running! !
testConnection!public!tests! !
withFixtures:do:!accessing!public! !
!

!MySQLTestCase class methodsFor!

fixtureClass	"Override this in order to offer test specific fixture class"	^ MySQLTestFixture	!

resourceClass	^ MySQLTestResource!

resources	^ Set new 		add: self resourceClass; 		yourself! !

!MySQLTestCase class categoriesForMethods!
fixtureClass!private! !
resourceClass!private! !
resources!private! !
!

