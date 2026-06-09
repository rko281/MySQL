"Filed out from Dolphin Smalltalk"!

MySQLTestCase subclass: #MySQLDriverTest
	instanceVariableNames: 'connector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'protocol'!

MySQLDriverTest guid: (GUID fromString: '{15301661-6818-4534-9984-1ef160eaac9e}')!

MySQLDriverTest comment: ''!

!MySQLDriverTest categoriesForClass!MySQL-Core-Tests-Integration-Driver! !

!MySQLDriverTest methodsFor!

badConnectionSpec	| connSpec |		connSpec := self goodConnectionSpec .	connSpec password: 'wrongpassword' .		^ connSpec!

goodConnectionSpec	^ MySQLTestResource driverSpecNoDb!

invalidHostNameConnectionSpec	| connSpec |		connSpec := self goodConnectionSpec .	connSpec host: 'souldfail.nodomain.zzz' .		^ connSpec!

setUp	super setUp.	connector := MySQLDriver new!

tearDown	connector connected ifTrue: [connector disconnect].	super tearDown!

testConnectAssorted	| connSpec |		connSpec := self goodConnectionSpec .	self assert: (connector connect: connSpec) isOkay.	connector disconnect.		connSpec := self badConnectionSpec .	self assert: (connector connect: connSpec) isError.	connector connected ifTrue: [connector disconnect].	connSpec := self goodConnectionSpec .	self assert: (connector connect: connSpec) isOkay .	connector disconnect.!

testConnectBad	| connSpec |	connSpec := self badConnectionSpec .	self assert: (connector connect: connSpec) isError .	!

testConnectGood	| connSpec resp |		connSpec := self goodConnectionSpec.	resp := connector connect: connSpec.	self assert: resp isOkay.	!

testConnectWithDb	| connSpec resp |	connSpec := self goodConnectionSpec.	connSpec db: MySQLTestResource dbName.	resp := connector connect: connSpec.	self assert: resp isOkay.	connector disconnect.	connSpec db: MySQLTestResource dbName reverse.	self assert: (connector connect: connSpec) isError.	connector connected ifTrue: [ connector disconnect].!

testDisconnect	| connSpec |		connSpec := self goodConnectionSpec .	self assert: (connector connect: connSpec) isOkay.	self shouldnt: [connector disconnect] raise: MySQLNoConnectionError .	self should: [connector disconnect] raise: MySQLNoConnectionError .!

testHostLookupError	| connSpec |	connSpec := self invalidHostNameConnectionSpec.	self should: [connector connect: connSpec] raise: MySQLNameLookupFailure.! !

!MySQLDriverTest categoriesForMethods!
badConnectionSpec!accessing!public! !
goodConnectionSpec!accessing!public! !
invalidHostNameConnectionSpec!accessing!public! !
setUp!public!running! !
tearDown!public!running! !
testConnectAssorted!public!tests! !
testConnectBad!public!tests! !
testConnectGood!public!tests! !
testConnectWithDb!public!tests! !
testDisconnect!public!tests! !
testHostLookupError!public!tests! !
!

