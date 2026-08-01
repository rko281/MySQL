"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLBindParameterIntegerTest
	instanceVariableNames: 'theParam'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBindParameterIntegerTest guid: (GUID fromString: '{e34870f6-35c2-4cd0-8c7f-b26836032026}')!

MySQLBindParameterIntegerTest comment: ''!

!MySQLBindParameterIntegerTest categoriesForClass!MySQL-Core-Tests-Utilities! !

!MySQLBindParameterIntegerTest methodsFor!

setUp	super setUp.	theParam := MySQLBindParameter new.	!

specText	"	Binding an integer in range -128 to 255		- should set the param type to TINY			Binding an integer in range -128 to -1		- should produce a 2's complement byte array of size 1 in binary protocol'	Binding an integer in range 0 to 255		- should produce a byte array of size 1 in binary protocol'	"!

storeBinary	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		^ strm contents]		!

testParamInBigIntRange	theParam bindValue: -16r8000000000000000.	self assert: (theParam paramType = MySQLTypes.TypeLONGLONG).	self deny: theParam isUnsigned.		theParam bindValue: -16r80000001.	self assert: (theParam paramType = MySQLTypes.TypeLONGLONG).	self deny: theParam isUnsigned.	theParam bindValue: 16r100000000.	self assert: (theParam paramType = MySQLTypes.TypeLONGLONG).	self assert: theParam isUnsigned.	self should: [theParam bindValue: 16rFFFFFFFFFFFFFFFF]  raise: MySQLBindError.	theParam declaredUnsigned: true.	theParam bindValue: 16rFFFFFFFFFFFFFFFF.	self assert: (theParam paramType = MySQLTypes.TypeLONGLONG).	self assert: theParam isUnsigned.!

testParamInLongIntRange	theParam bindValue: -16r80000000.	self assert: (theParam paramType = MySQLTypes.TypeLONG).	self deny: theParam isUnsigned.		theParam bindValue: -16r8001.	self assert: (theParam paramType = MySQLTypes.TypeLONG).	self deny: theParam isUnsigned.	theParam bindValue: 16r10000.	self assert: (theParam paramType = MySQLTypes.TypeLONG).	self assert: theParam isUnsigned.	theParam bindValue: 16rFFFFFFFF.	self assert: (theParam paramType = MySQLTypes.TypeLONGLONG).	self assert: theParam isUnsigned.	theParam declaredUnsigned: true.	theParam bindValue: 16rFFFFFFFF.	self assert: (theParam paramType = MySQLTypes.TypeLONG).	self assert: theParam isUnsigned.!

testParamInShortIntRange	theParam bindValue: -16r8000.	self assert: (theParam paramType = MySQLTypes.TypeSHORT).	self deny: theParam isUnsigned.		theParam bindValue: -16r81.	self assert: (theParam paramType = MySQLTypes.TypeSHORT).	self deny: theParam isUnsigned.	theParam bindValue: 16r100.	self assert: (theParam paramType = MySQLTypes.TypeSHORT).	self assert: theParam isUnsigned.	theParam bindValue: 16rFFFF.	self assert: (theParam paramType = MySQLTypes.TypeLONG).	self assert: theParam isUnsigned.	theParam declaredUnsigned: true.	theParam bindValue: 16rFFFF.	self assert: (theParam paramType = MySQLTypes.TypeSHORT).	self assert: theParam isUnsigned.!

testParamInTinyIntRange	theParam bindValue: -128.	self assert: (theParam paramType = MySQLTypes.TypeTINY).	theParam bindValue: 0.	self assert: (theParam paramType = MySQLTypes.TypeTINY).	theParam bindValue: 255.	self assert: (theParam paramType = MySQLTypes.TypeSHORT).!

testParamOutOfBigIntRange	self should: [theParam bindValue: -16r8000000000000001] raise: MySQLBindError.	theParam bindValue: -16r80000000.	self deny: (theParam paramType = MySQLTypes.TypeLONGLONG).	theParam declaredUnsigned: true.	theParam bindValue: 16rFFFFFFFF.	self deny: (theParam paramType = MySQLTypes.TypeLONGLONG).	self should: [theParam bindValue: 16r10000000000000000] raise: MySQLBindError.!

testParamOutOfLongIntRange	theParam bindValue: -16r80000001.	self deny: (theParam paramType = MySQLTypes.TypeLONG).	theParam bindValue: -16r8000.	self deny: (theParam paramType = MySQLTypes.TypeLONG).	theParam declaredUnsigned: true.	theParam bindValue: 16rFFFF.	self deny: (theParam paramType = MySQLTypes.TypeLONG).	theParam bindValue: 16r100000000.	self deny: (theParam paramType = MySQLTypes.TypeLONG).!

testParamOutOfShortIntRange	theParam bindValue: -16r8001.	self deny: (theParam paramType = MySQLTypes.TypeSHORT).	theParam bindValue: -16r80.	self deny: (theParam paramType = MySQLTypes.TypeSHORT).	theParam declaredUnsigned: true.	theParam bindValue: 16rFF.	self deny: (theParam paramType = MySQLTypes.TypeSHORT).	theParam bindValue: 16r10000.	self deny: (theParam paramType = MySQLTypes.TypeSHORT).!

testParamOutOfTinyIntRange	theParam bindValue: -129.	self deny: (theParam paramType = MySQLTypes.TypeTINY).	theParam bindValue: 256.	self deny: (theParam paramType = MySQLTypes.TypeTINY).!

testStoreBinaryBigInt	theParam bindValue: -16r8000000000000000.	self assert: (self storeBinary = 		(MySQLHelper bytesFromHexString: '0000000000000080')).	theParam bindValue: -16r80000001.	self assert: (self storeBinary = 		(MySQLHelper bytesFromHexString: 'FFFFFF7FFFFFFFFF')).	theParam bindValue: 16r100000000.	self assert: (self storeBinary = 		(MySQLHelper bytesFromHexString: '0000000001000000')).	self should: [theParam bindValue: 16rFFFFFFFFFFFFFFFF] raise: MySQLBindError.	theParam declaredUnsigned: true.		theParam bindValue: 16rFFFFFFFFFFFFFFFF.	self assert: (self storeBinary = 		(MySQLHelper bytesFromHexString: 'FFFFFFFFFFFFFFFF')).!

testStoreBinaryLongInt	theParam bindValue: -16r80000000.	self assert: (self storeBinary = 		(MySQLHelper bytesFromHexString: '00000080')).	theParam bindValue: -16r8001.	self assert: (self storeBinary = 		(MySQLHelper bytesFromHexString: 'FF7FFFFF')).	theParam bindValue: 16r10000.	self assert: (self storeBinary = 		(MySQLHelper bytesFromHexString: '00000100')).	theParam declaredUnsigned: true.	theParam bindValue: 16rFFFFFFFF.	self assert: (self storeBinary = 		(MySQLHelper bytesFromHexString: 'FFFFFFFF')).	!

testStoreBinaryShortInt	theParam bindValue: -16r8000.	self assert: (self storeBinary = (ByteArray with: 16r00 with: 16r80)).	theParam bindValue: -16r81.	self assert: (self storeBinary = (ByteArray with: 16r7F with: 16rFF)).	theParam bindValue: 16r100.	self assert: (self storeBinary = (ByteArray with: 16r00 with: 16r01)).	theParam declaredUnsigned: true.	theParam bindValue: 16rFFFF.	self assert: (self storeBinary = (ByteArray with: 16rFF with: 16rFF)).	!

testStoreBinaryTinyInt	theParam bindValue: -128.	self assert: (self storeBinary = (ByteArray with: 16r80)).	theParam bindValue: -1.	self assert: (self storeBinary = (ByteArray with: 16rFF)).	theParam bindValue: 0.	self assert: (self storeBinary = (ByteArray with: 16r00)).	theParam declaredUnsigned: true.	theParam bindValue: 255.	self assert: (self storeBinary = (ByteArray with: 16rFF)).	! !

!MySQLBindParameterIntegerTest categoriesForMethods!
setUp!public!running! !
specText!accessing!public! !
storeBinary!accessing!public! !
testParamInBigIntRange!public!tests! !
testParamInLongIntRange!public!tests! !
testParamInShortIntRange!public!tests! !
testParamInTinyIntRange!public!tests! !
testParamOutOfBigIntRange!public!tests! !
testParamOutOfLongIntRange!public!tests! !
testParamOutOfShortIntRange!public!tests! !
testParamOutOfTinyIntRange!public!tests! !
testStoreBinaryBigInt!public!tests! !
testStoreBinaryLongInt!public!tests! !
testStoreBinaryShortInt!public!tests! !
testStoreBinaryTinyInt!public!tests! !
!

