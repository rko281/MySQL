"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLBindParameterBooleanTest
	instanceVariableNames: 'theParam'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBindParameterBooleanTest guid: (GUID fromString: '{2932ea21-c59d-4dbd-a423-788cfa4b4fbf}')!

MySQLBindParameterBooleanTest comment: ''!

!MySQLBindParameterBooleanTest categoriesForClass!MySQL-Core-Tests-Utilities! !

!MySQLBindParameterBooleanTest methodsFor!

setUp	theParam := MySQLBindParameter new.	!

storeBinary	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		^ strm contents]		!

testParamBoolean	theParam bindValue: true.	self assert: (theParam detectParamType = MySQLTypes typeTINY).	self assert: theParam isUnsigned.	theParam bindValue: false.	self assert: (theParam detectParamType = MySQLTypes typeTINY).	self assert: theParam isUnsigned.!

testParamStoreBinaryBoolean	theParam bindValue: true.	self assert: (self storeBinary = (ByteArray with: 16r01)).	theParam bindValue: false.	self assert: (self storeBinary = (ByteArray with: 16r00)).! !

!MySQLBindParameterBooleanTest categoriesForMethods!
setUp!public!running! !
storeBinary!accessing!public! !
testParamBoolean!public!tests! !
testParamStoreBinaryBoolean!public!tests! !
!

