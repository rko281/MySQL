"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLBindParameterDateTimeTest
	instanceVariableNames: 'theParam'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBindParameterDateTimeTest guid: (GUID fromString: '{c3b806dd-a84e-4b2b-95bd-d2ceb393f762}')!

MySQLBindParameterDateTimeTest comment: ''!

!MySQLBindParameterDateTimeTest categoriesForClass!MySQL-Core-Tests-Utilities! !

!MySQLBindParameterDateTimeTest methodsFor!

expectedFailures 	^super expectedFailures, #(#testParamTimestamp )!

setUp	theParam := MySQLBindParameter new.	!

storeBinary	ByteArray streamContents: [:strm | 		theParam storeBinaryOn: strm.		^ strm contents]		!

testParamDate	theParam bindValue: (Date fromString: '06-21-2011' format: 'mm-dd-yyyy').	self assert: (theParam detectParamType = MySQLTypes.TypeDATE).	self assert: theParam isUnsigned.		!

testParamDateTime	theParam bindValue: DateAndTime now.	self assert: (theParam detectParamType = MySQLTypes.TypeDATETIME).	self assert: theParam isUnsigned.	!

testParamDuration	theParam bindValue: (Duration fromString: '10:02:30:45').	self assert: (theParam detectParamType = MySQLTypes.TypeTIME).	self assert: theParam isUnsigned.	theParam bindValue: (Duration fromString: '-10:02:30:45').	self assert: (theParam detectParamType = MySQLTypes.TypeTIME).	self assert: theParam isUnsigned not.	!

testParamTime	theParam bindValue: Time now.	self assert: (theParam detectParamType = MySQLTypes.TypeTIME).	self assert: theParam isUnsigned.	!

testParamTimestamp	"Currently an expected failure - this directly contradicts testParamDateTime.	Needs an explicit Timestamp class to map to MySQL typeTIMESTAMP"	true ifTrue: [^self].
	theParam bindValue: DateAndTime now.	self assert: (theParam detectParamType = MySQLTypes.TypeTIMESTAMP).	self assert: theParam isUnsigned.	!

testStoreBinaryDate	theParam bindValue: (Date fromString: '06-21-2011' format: 'mm-dd-yyyy').	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) equals: '04DB070615'	!

testStoreBinaryDateAndTime	theParam bindValue: ##(DateAndTime fromString: '1901-01-01T00:00:00.000000'). "Squeak epoch: 1901-01-01"	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '046D070101'.	theParam bindValue: (DateAndTime fromString: '2011-06-21T16:45:30.00000000').	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '07DB070615102D1E'.		theParam bindValue: (DateAndTime fromString: '2011-06-21T16:45:30.00123456').	"Since the microseconds are stored form the nano (1234 from 1234560 ns)"	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '0BDB070615102D1ED2040000'.	!

testStoreBinaryDuration	theParam bindValue: (Duration zero).	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '00'.	theParam bindValue: (Duration fromString: '10:02:30:45').	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '08000A000000021E2D'.	theParam bindValue: (Duration fromString: '-10:02:30:45').	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '08010A000000021E2D'.	theParam bindValue: (Duration fromString: '10:02:30:45.1234').	self assert: 		(MySQLHelper hexStringFromBytes: self storeBinary) = '0C000A000000021E2D08E20100'.	!

testStoreBinaryTime	theParam bindValue: (Time fromSeconds: 0).	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '00'.	theParam bindValue: (Time fromString: '16:02:30').	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '08000000000010021E'.	theParam bindValue: (Time hours: 16 minutes: 02 seconds: (30 + (1234000/1e9))).	self assert: 		(MySQLHelper hexStringFromBytes: self storeBinary) = '0C000000000010021ED2040000'.	!

testStoreBinaryTimeStamp	theParam bindValue: ##(DateAndTime fromString: '1901-01-01T00:00:00.000000'). "Squeak epoch: 1901-01-01"	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '046D070101'.	theParam bindValue: (DateAndTime year: 2011 month: 06 day: 21							hour: 16 minute:45 second:30).	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '07DB070615102D1E'.		theParam bindValue: (DateAndTime year: 2011 month: 06 day: 21							hour: 16 minute:45 second:(30+ (123456/1e9))).	self assert: (MySQLHelper hexStringFromBytes: self storeBinary) = '0BDB070615102D1E7B000000'.	! !

!MySQLBindParameterDateTimeTest categoriesForMethods!
expectedFailures!public!tests! !
setUp!public!running! !
storeBinary!accessing!public! !
testParamDate!public!tests! !
testParamDateTime!public!tests! !
testParamDuration!public!tests! !
testParamTime!public!tests! !
testParamTimestamp!public!tests! !
testStoreBinaryDate!public!tests! !
testStoreBinaryDateAndTime!public!tests! !
testStoreBinaryDuration!public!tests! !
testStoreBinaryTime!public!tests! !
testStoreBinaryTimeStamp!public!tests! !
!

