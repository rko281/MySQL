"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLBinaryReaderTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBinaryReaderTest guid: (GUID fromString: '{3fbeef26-f89c-4def-bef3-6a69b4851851}')!

MySQLBinaryReaderTest comment: ''!

!MySQLBinaryReaderTest categoriesForClass!MySQL-Core-Tests-Utilities! !

!MySQLBinaryReaderTest methodsFor!

scenarioReadDate'Reading binary DATE- should be a Date with specified <day>, <month>, <year>- should ignore fields other than <day>, <month>, <year>'!

scenarioReadDateTime'Reading binary DATETIME- should be a DateTime reading only <year>, <month> and <day> when <length> eq 4 bytes- should be a DateTime also reading <hh>, <mm>, <ss> when <length> gt 4 bytes- should be a DateTime also reading nanosecond part when <length> gt 7 bytes'!

scenarioReadTime'Reading binary TIME- should be a negative Duration when <sign> is non-zero- should be a Duration when only <days> field present- should be a Duration when <days> gt 0- should be a Time set to zero hour when <length> is 0- should be a Time when <sign> is positive and <days> eq 0- should read the <days> part when supplied- should read the <hh>:<mm>:<ss> part when supplied- should read the <subseconds> part when supplied'!

testReadDateIgnoeTimeFields	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(11 219 7 5 31 14 30 45 1 2 3 4). "2011-05-31, 14:30:45, micros"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader dateFrom: strm) = (Date fromString: 'May 31 2011' format: 'MMM dd yy')		description: 'should be a Date ignoring fields other than year, month, day'.		!

testReadDateTimeWithDateFieldsOnly	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(4 219 7 5 31). "2011-05-31"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader dateTimeFrom: strm) = 				(DateAndTime					"localTimeZone: TimeZone default;"					fromString: '2011-05-31T00:00:00.000000000')		description: 'should be a DateTime reading only date fields when <length> eq 4 bytes'.		!

testReadDateTimeWithDateTimeFields	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(7 219 7 5 31 14 30 45). "2011-05-31, 14:30:45"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader dateTimeFrom: strm) 			= (DateAndTime "				localTimeZone: TimeZone default;			"				fromString: '2011-05-31T14:30:45.000000000')		description: 'should be a DateTime reading date & time fields when <length> eq 7 bytes'.		!

testReadDateTimeWithSubsecondField	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(11 219 7 5 31 14 30 45 255 1 0 0). "2011-05-31, 14:30:45, 511 us"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader dateTimeFrom: strm) 			= (DateAndTime 				"localTimeZone: TimeZone default;"				fromString: '2011-05-31T14:30:45.000511000')		description: 'should be a DateTime reading all fields when <length> eq 11 bytes'.		!

testReadDateWithDateFieldsOnly	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(4 219 7 5 31). "2011-05-31"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader dateFrom: strm) = (Date fromString: 'May 31 2011' format: 'MMM dd yy')		description: 'should be a Date with specified year, month, day'.		!

testReadDecimalWithScale	| aStream reader |	aStream := ReadWriteStream on: ByteArray new.	MySQLHelper encodeLcs: '12345.6789' asByteArray on: aStream.		aStream reset.		reader := MySQLBinaryReader default.	self assert: (reader decimalWithScale: 4 from: aStream) = ('12345.6789s4' asNumber).!

testReadDouble	| aStream reader |	aStream := ReadWriteStream on: ByteArray new.	aStream nextPut: 16r00; nextPut: 16r00; nextPut: 16r00; nextPut: 16r00.	aStream nextPut: 16r00; nextPut: 16r40; nextPut: 16r50; nextPut: 16r40.	aStream reset.		reader := MySQLBinaryReader default.	self assert: (reader doubleFrom: aStream) = 65.0.	!

testReadFloat	| aStream reader |	aStream := ReadWriteStream on: ByteArray new.	aStream nextPut: 16r00; nextPut: 16r00; nextPut: 16r82; nextPut: 16r42.	aStream reset.		reader := MySQLBinaryReader default.	self assert: (reader floatFrom: aStream) = 65.0.	!

testReadLongInt	| aStream reader |	aStream := ReadWriteStream on: ByteArray new.	aStream 		nextPut: 16r41; 		nextPut: 16r13;		nextPut: 16r64;		nextPut: 16rF0;		nextPut: 16r41; 		nextPut: 16r13;		nextPut: 16r64;		nextPut: 16rF0.	aStream reset.	reader := MySQLBinaryReader default.	self assert: (reader bigIntFrom: aStream) = 17321991240700662593.!

testReadMediumInt	| aStream reader |	aStream := ReadWriteStream on: ByteArray new.	aStream 		nextPut: 16r41; 		nextPut: 16r13;		nextPut: 16r64;		nextPut: 16r00.	aStream reset.	reader := MySQLBinaryReader default.	self assert: (reader mediumIntFrom: aStream) = 6558529.!

testReadShortInt	| aStream reader |	aStream := ReadWriteStream on: ByteArray new.	aStream 		nextPut: 65; 		nextPut: 2.	aStream reset.	reader := MySQLBinaryReader default.	self assert: (reader smallIntFrom: aStream) = 577.!

testReadTimeWithDaysAndTime	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(16r08 16r00 16r11 16r22 16r33 16r44 16r0A 16r0B 16r0C). 		" implies duration of 1144201745:10:11:12"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader timeFrom: strm) 			= (Duration fromString: '1144201745:10:11:12')		description: 'should be a Duration with time part if given when <days> is non zero'.		!

testReadTimeWithDaysOnly	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(16r05 16r00 16r11 16r22 16r33 16r44). " implies duration of 1144201745"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader timeFrom: strm) 			equals: (Duration days: 1144201745)		description: 'should be a Duration when only <days> field present'.		!

testReadTimeWithDaysTimeAndSubseconds	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(16r0C 16r00 16r11 16r22 16r33 16r44 16r0A 16r0B 16r0C		16r04 16r03 16r02 16r00). 		" implies duration of 1144201745:10:11:12.131844000"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader timeFrom: strm) 			= (Duration fromString: '1144201745:10:11:12.131844000')		description: 'should be a Duration with subseconds if given when <days> is non zero'.		!

testReadTimeWithNegSign	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(16r08 16r01 16r00 16r00 16r00 16r00 16r0A 16r0B 16r0C). 		" implies duration of -1144201745:10:11:12"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader timeFrom: strm) 			= (Duration fromString: '-0:10:11:12')		description: 'should be a Duration when <sign> is indicated negative'.		!

testReadTimeWithNoDaysButWithTime	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(16r08 16r00 16r00 16r00 16r00 16r00 16r0A 16r0B 16r0C). 		" implies time of 10:11:12"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader timeFrom: strm) 			= (Time fromString: '10:11:12')		description: 'should be a Time when <days> is zero'.		!

testReadTimeWithNoDaysButWithTimeAndSubseconds	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(16r0C 16r00 16r00 16r00 16r00 16r00 16r0A 16r0B 16r0C		16r04 16r03 16r02 16r00). 		" implies time of 10:11:12.131844000"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader timeFrom: strm) 			= (Time hours: 10 minutes:11 seconds:(12 + (131844000 /1e9)))		description: 'should be a Time with subseconds if given when <days> is zero'.		!

testReadTimeWithZeroDaysOnly	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(16r05 16r00 16r00 16r00 16r00 16r00). " implies duration of 1144201745"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (Duration seconds: (reader timeFrom: strm) asSeconds)		equals: (Duration fromString: '00:00:00:00')		description: 'should be a zero hour Time when only <days> field present and is zero'.		!

testReadTimeZeroHour	| strm reader |	strm := ReadWriteStream on: ByteArray new.	strm nextPutAll: #(0). " implies 00:00:00"	strm reset.		reader := MySQLBinaryReader default.	self 		assert: (reader timeFrom: strm) 			= (Time fromString: '00:00:00')		description: 'should be a zero-hour Time when length is zero'.		!

testReadTinyInt	| aStream reader |	aStream := ReadWriteStream on: ByteArray new.	aStream nextPut: 65.	aStream reset.		reader := MySQLBinaryReader default.	self assert: (reader tinyIntFrom: aStream) = 65.	!

testReadVarBlob	| aStream reader longString |	aStream := ReadWriteStream on: ByteArray new.	longString := 		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890'.			MySQLHelper 		encodeLcs: (longString first: 9) asByteArray on: aStream;		encodeLcs: longString asByteArray 	on: aStream.				aStream reset.		reader := MySQLBinaryReader default.	self assert: (reader varBlobFrom: aStream) = '123456789' asByteArray.	self assert: (reader varBlobFrom: aStream) = longString asByteArray.	!

testReadVarString	| aStream reader longString |	aStream := ReadWriteStream on: ByteArray new.	longString := 		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890',		'12345678901234567890123456789012345678901234567890'.			MySQLHelper 		encodeLcs: (longString first: 9) asByteArray on: aStream;		encodeLcs: longString asByteArray 	on: aStream.				aStream reset.		reader := MySQLBinaryReader default.	self assert: (reader varStringFrom: aStream) = '123456789'.	self assert: (reader varStringFrom: aStream) = longString.	! !

!MySQLBinaryReaderTest categoriesForMethods!
scenarioReadDate!public!scenarios! !
scenarioReadDateTime!public!scenarios! !
scenarioReadTime!public!scenarios! !
testReadDateIgnoeTimeFields!public!tests / reading / date! !
testReadDateTimeWithDateFieldsOnly!public!tests / reading / date! !
testReadDateTimeWithDateTimeFields!public!tests / reading / date! !
testReadDateTimeWithSubsecondField!public!tests / reading / date! !
testReadDateWithDateFieldsOnly!public!tests / reading / date! !
testReadDecimalWithScale!public!tests / reading / numbers! !
testReadDouble!public!tests / reading / numbers! !
testReadFloat!public!tests / reading / numbers! !
testReadLongInt!public!tests / reading / numbers! !
testReadMediumInt!public!tests / reading / numbers! !
testReadShortInt!public!tests / reading / numbers! !
testReadTimeWithDaysAndTime!public!tests / reading / time! !
testReadTimeWithDaysOnly!public!tests / reading / time! !
testReadTimeWithDaysTimeAndSubseconds!public!tests / reading / time! !
testReadTimeWithNegSign!public!tests / reading / time! !
testReadTimeWithNoDaysButWithTime!public!tests / reading / time! !
testReadTimeWithNoDaysButWithTimeAndSubseconds!public!tests / reading / time! !
testReadTimeWithZeroDaysOnly!public!tests / reading / time! !
testReadTimeZeroHour!public!tests / reading / time! !
testReadTinyInt!public!tests / reading / numbers! !
testReadVarBlob!public!tests / reading! !
testReadVarString!public!tests / reading! !
!

