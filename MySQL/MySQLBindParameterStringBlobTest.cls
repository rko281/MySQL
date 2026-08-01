"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLBindParameterStringBlobTest
	instanceVariableNames: 'theParam'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBindParameterStringBlobTest guid: (GUID fromString: '{72e62abb-8a47-41d8-97e9-48f6cf12dda7}')!

MySQLBindParameterStringBlobTest comment: ''!

!MySQLBindParameterStringBlobTest categoriesForClass!MySQL-Core-Tests-Utilities! !

!MySQLBindParameterStringBlobTest methodsFor!

setUp	theParam := MySQLBindParameter new.	!

storeBinary	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		^ strm contents]		!

testParamBlob	theParam bindValue: (ByteArray new: 16rFF withAll: 16rAA).	self assert: (theParam detectParamType = MySQLTypes.TypeTINYBLOB).	self assert: theParam isUnsigned.	theParam bindValue: (ByteArray new: 16rFFFF withAll: 16r55).	self assert: (theParam detectParamType = MySQLTypes.TypeBLOB).	self assert: theParam isUnsigned.	theParam bindValue: (ByteArray new: 16r20000 withAll: 16rAA).	self assert: (theParam detectParamType = MySQLTypes.TypeMEDIUMBLOB).	self assert: theParam isUnsigned.	theParam bindValue: (ByteArray new: 16r1000000 withAll: 16r55).	self assert: (theParam detectParamType = MySQLTypes.TypeLONGBLOB).	self assert: theParam isUnsigned.		!

testParamCharacter	theParam bindValue: $A.	self assert: (theParam detectParamType = MySQLTypes.TypeSTRING).	self assert: theParam isUnsigned.!

testParamStoreBinaryCharacter	theParam bindValue: $A.	"lengthcoded + charcter as string"	self assert: (self storeBinary = (ByteArray with: 1 with: 16r41)).!

testParamStoreBinaryString	| value binStrm |	theParam bindValue: 'hello'.	"lengthcoded + string bytes"	self assert: self storeBinary equals: ((ByteArray with: 5), 'hello' asByteArray).	value := ''.	10 timesRepeat: [value := value, 'abcdefghijklmnopqrstuvwxyz'].	theParam bindValue: value.	binStrm := ReadStream on: self storeBinary.	self assert: (MySQLHelper decodeLcbFrom: binStrm) = 260.	self assert: (binStrm upToEnd asString = value)		!

testParamStoreBinarySymbol	theParam bindValue: #hello.	"lengthcoded + string bytes"	self assert: (self storeBinary = ((ByteArray with: 5), 'hello' asByteArray)).!

testParamString	theParam bindValue: 'Smalltalk is awesome'.	self assert: (theParam detectParamType = MySQLTypes.TypeVARSTRING).	self assert: theParam isUnsigned.	!

testParamSymbol	theParam bindValue: #'Symbols are special'.	self assert: (theParam detectParamType = MySQLTypes.TypeVARSTRING).	self assert: theParam isUnsigned.	! !

!MySQLBindParameterStringBlobTest categoriesForMethods!
setUp!public!running! !
storeBinary!accessing!public! !
testParamBlob!public!tests! !
testParamCharacter!public!tests! !
testParamStoreBinaryCharacter!public!tests! !
testParamStoreBinaryString!public!tests! !
testParamStoreBinarySymbol!public!tests! !
testParamString!public!tests! !
testParamSymbol!public!tests! !
!

