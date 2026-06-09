"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLBindParameterRealTest
	instanceVariableNames: 'theParam'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBindParameterRealTest guid: (GUID fromString: '{a8dfaf2a-7df6-434f-8918-65b26268e54c}')!

MySQLBindParameterRealTest comment: ''!

!MySQLBindParameterRealTest categoriesForClass!MySQL-Core-Tests-Utilities! !

!MySQLBindParameterRealTest methodsFor!

setUp	theParam := MySQLBindParameter new	!

storeBinary	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		^ strm contents]	!

testParamDecimal	theParam bindValue: 12345.678901s6.	self assert: theParam paramType = MySQLTypes typeDECIMAL.	self assert: theParam isUnsigned.		theParam bindValue: -12345.678901s6.	self assert: theParam paramType = MySQLTypes typeDECIMAL.	self deny: theParam isUnsigned.!

testParamDouble	theParam bindValue: 123456789123456789.123456789.	self assert: theParam paramType = MySQLTypes typeDOUBLE.	self assert: theParam isUnsigned.		theParam bindValue: -123456789123456789.123456789.	self assert: theParam paramType = MySQLTypes typeDOUBLE.	self deny: theParam isUnsigned.!

testParamFloat	theParam bindValue: 65.0.	self assert: theParam paramType = MySQLTypes typeDOUBLE.	self assert: theParam isUnsigned.	theParam bindValue: -65.0.	self assert: theParam paramType = MySQLTypes typeDOUBLE.	self deny: theParam isUnsigned.	!

testParamFraction	theParam bindValue: 100/3.	self assert: theParam paramType = MySQLTypes typeDOUBLE.	self assert: theParam isUnsigned.	theParam bindValue: -100/3.	self assert: theParam paramType = MySQLTypes typeDOUBLE.	self deny: theParam isUnsigned.		theParam bindValue: 17/4.	self assert: theParam paramType = MySQLTypes typeDOUBLE.	self assert: theParam isUnsigned.		theParam bindValue: -17/4.	self assert: theParam paramType = MySQLTypes typeDOUBLE.	self deny: theParam isUnsigned.	!

testStoreBinarySignedDecimal	theParam bindValue: -12345.678901s6.	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		self assert: strm contents asString equals: ((String with: (Character value: 13 "Length")), '-12345.678901')]	!

testStoreBinarySignedDouble	theParam bindValue: -123456789123456789.123456789.	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		self assert: strm contents 			equals: 				(MySQLHelper bytesFromHexString: 'F105CDBAB4697BC3')]!

testStoreBinarySignedFraction	theParam bindValue: -17/4.	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		self assert: (strm contents 			= (MySQLHelper bytesFromHexString: '00000000000011C0'))]		!

testStoreBinarySingedFloat	theParam bindValue: -65.0.	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		self assert: (strm contents 			= (MySQLHelper bytesFromHexString: '00000000004050C0'))]		!

testStoreBinaryUnsignedDecimal	theParam bindValue: 12345.678901s6.	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		self assert: (strm contents asString = ((String with: (Character value: 12 "Length")), '12345.678901'))]	!

testStoreBinaryUnsignedDouble	theParam bindValue: 123456789123456789.123456789.	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		self assert: (strm contents 			= (MySQLHelper bytesFromHexString: 'F105CDBAB4697B43'))]		!

testStoreBinaryUnsignedFloat	theParam bindValue: 65.0.	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		self assert: (strm contents 			= (MySQLHelper bytesFromHexString: '0000000000405040'))]		!

testStoreBinaryUnsignedFraction	theParam bindValue: 17/4.	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		self assert: (strm contents 			= (MySQLHelper bytesFromHexString: '0000000000001140'))]		! !

!MySQLBindParameterRealTest categoriesForMethods!
setUp!public!running! !
storeBinary!accessing!public! !
testParamDecimal!public!tests! !
testParamDouble!public!tests! !
testParamFloat!public!tests! !
testParamFraction!public!tests! !
testStoreBinarySignedDecimal!public!tests! !
testStoreBinarySignedDouble!public!tests! !
testStoreBinarySignedFraction!public!tests! !
testStoreBinarySingedFloat!public!tests! !
testStoreBinaryUnsignedDecimal!public!tests! !
testStoreBinaryUnsignedDouble!public!tests! !
testStoreBinaryUnsignedFloat!public!tests! !
testStoreBinaryUnsignedFraction!public!tests! !
!

