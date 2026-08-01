"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLBindParameter
	instanceVariableNames: 'paramValue paramType newParamBound unsignedFlag declaredUnsigned sentAsLongData'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBindParameter guid: (GUID fromString: '{30fb5eb1-2986-4b93-ad3e-da43fecdbd07}')!

MySQLBindParameter comment: 'Database bind parameter for MySQL'!

!MySQLBindParameter categoriesForClass!MySQL-Core-Utilities! !

!MySQLBindParameter methodsFor!

bindValue: aValue 
	| boundType |

	paramValue := aValue.
	(boundType := (aValue mySQLParamTypeFor: self)) ~= paramType 
		ifTrue: [
			paramType := boundType.
			newParamBound := true].
	unsignedFlag := aValue mySQLParamSign!

dateTimeBytes

	| strm dt year length micros |		strm := ReadWriteStream on: (ByteArray new: 12).	dt := (paramValue class = DateAndTime ifTrue: [paramValue] ifFalse: [paramValue asDateAndTime]).	length := 0.	strm nextPut: length.	"will re-adjust this as different conditions are found"	year := dt year.	strm		nextPut: (year byteAt: 1);		nextPut: (year byteAt: 2);		"year"			nextPut: (dt month byteAt: 1);		nextPut: (dt dayOfMonth byteAt: 1).	strm		nextPut: (dt hour byteAt: 1);		nextPut: (dt minute byteAt: 1);		nextPut: (dt second truncated byteAt: 1).	micros := dt nanosecond // 1000.	strm		nextPut: (micros byteAt: 1);		nextPut: (micros byteAt: 2);		nextPut: (micros byteAt: 3);		nextPut: (micros byteAt: 4).	"Update the length field now."	length := 11.	micros = 0		ifTrue: [ length := 7.	"no sub-seconds to send"			((dt hour = 0 and: [ dt minute = 0 ]) and: [ dt second = 0 ])				ifTrue: [ "no hh:mm:ss to send"					length := 4.					(dt year = 0 and: [ dt month = 0 and: [ dt day = 0 ] ])						ifTrue: [ "no yy-mm-dd to send" length := 0 ] ] ].	^strm		reset;		nextPut: length;		reset;
		next: length + 1	"remember to send the length byte itself"!

decimalBytes	"For scaled decimal"	^ByteArray streamContents: [:strm |		MySQLHelper encodeLcs: paramValue displayString asByteArray on: strm.		strm contents]!

declaredUnsigned: aBoolean	declaredUnsigned := aBoolean	!

detectParamType
	"Corresponding database type needs to be inferred from the bound value"
	^paramValue mySQLParamTypeFor: self!

doubleBytes		^(ByteArray new: 8)
		doubleAtOffset: 0 put: paramValue asFloat;
		yourself!

floatBytes		^ByteArray		streamContents: [ :strm | | storable |			storable := paramValue asFloat at: 1.	"indexed accedd into a Float"			strm				nextPut: (storable byteAt: 1);				nextPut: (storable byteAt: 2);				nextPut: (storable byteAt: 3);				nextPut: (storable byteAt: 4) ]!

initialize	newParamBound := false.	paramType := MySQLTypes.TypeNULL.	unsignedFlag := declaredUnsigned := false.	sentAsLongData := false!

integerBytes: size		^ByteArray		streamContents: [ :strm | | storable |			storable := self storableIntegerValueOfSize: size.			1 to: size do: [ :ii | strm nextPut: (storable byteAt: ii) ] ]!

isDeclaredUnsigned	^ declaredUnsigned  	!

isInBigIntRange: anInteger
	^ self isDeclaredUnsigned 
		ifTrue: [anInteger between: 16r0000000000000000 and: 16rFFFFFFFFFFFFFFFF] 
		ifFalse: [anInteger between: -16r8000000000000000 and: 16r7FFFFFFFFFFFFFFF]!

isInLongIntRange: anInteger
	^ self isDeclaredUnsigned 
		ifTrue: [anInteger between: 16r00000000 and: 16rFFFFFFFF] 
		ifFalse: [anInteger between: -16r80000000 and: 16r7FFFFFFF]!

isInSmallIntRange: anInteger
	^ self isDeclaredUnsigned 
		ifTrue: [anInteger between: 16r0000 and: 16rFFFF]
		ifFalse: [anInteger between: -16r8000 and: 16r7FFF]!

isInTinyIntRange: anInteger
	^ self isDeclaredUnsigned 
		ifTrue: [anInteger between: 16r00 and: 16rFF] 
		ifFalse: [anInteger between: -16r80 and: 16r7F]!

isLongData
	^paramValue notNil and: [(self paramType = MySQLTypes.TypeVARCHAR or: [self paramType between: MySQLTypes.TypeLONGBLOB and: MySQLTypes.TypeSTRING]) and: [paramValue size > 1048576 "1MB"]]!

isNull	^ paramType = MySQLTypes.TypeNULL!

isRebound	^ newParamBound 	!

isUnsigned	^ unsignedFlag 	!

paramType	^ paramType 	!

resetReboundFlag	newParamBound := false	!

sentAsLongData	^ sentAsLongData	!

sentAsLongData: aBoolean	sentAsLongData := aBoolean	!

storableIntegerValueOfSize: size 	(paramValue isKindOf: Boolean) ifTrue: [^ paramValue ifTrue: [1] ifFalse: [0]].	^ paramValue negative 		ifTrue: [ (1 << (size * 8)) + paramValue ]		ifFalse: [ paramValue ]!

storeBinaryOn: aStream		
	paramType = MySQLTypes.TypeNULL ifTrue: [^nil].
	paramType = MySQLTypes.TypeTINY ifTrue: [^aStream nextPutAll: (self integerBytes: 1)].
	paramType = MySQLTypes.TypeSHORT ifTrue: [^aStream nextPutAll: (self integerBytes: 2)].
	paramType = MySQLTypes.TypeLONG ifTrue: [^aStream nextPutAll: (self integerBytes: 4)].		
	paramType = MySQLTypes.TypeLONGLONG ifTrue: [^aStream nextPutAll: (self integerBytes: 8)].	
	paramType = MySQLTypes.TypeFLOAT ifTrue: [^aStream nextPutAll: (self floatBytes)].
	paramType = MySQLTypes.TypeDOUBLE ifTrue: [^aStream nextPutAll: (self doubleBytes)].
	paramType = MySQLTypes.TypeTIME ifTrue: [^aStream nextPutAll: self timeBytes].
	paramType = MySQLTypes.TypeDATE ifTrue: [^aStream nextPutAll: self dateTimeBytes].
	paramType = MySQLTypes.TypeTIMESTAMP ifTrue: [^aStream nextPutAll: self dateTimeBytes].
	paramType = MySQLTypes.TypeDATETIME ifTrue: [^aStream nextPutAll: self dateTimeBytes].	
	paramType = MySQLTypes.TypeDECIMAL ifTrue: [^aStream nextPutAll: self decimalBytes].

	aStream nextPutAll: self stringOrBlobBytes!

stringOrBlobBytes			^ByteArray streamContents: [:strm |		MySQLHelper encodeLcs: self stringOrBlobBytesRaw on: strm]	!

stringOrBlobBytesRaw	^ paramValue asByteArray!

timeBytes

	| strm dur days length micros |

	strm := ReadWriteStream on: (ByteArray new: 12).	"length byte plus rest"	dur := Duration seconds: paramValue asSeconds.	length := 0.	strm nextPut: length.	"will re-adjust this as different conditions are found"	dur negative		ifTrue: [ strm nextPut: 1 ]		ifFalse: [ strm nextPut: 0 ].	days := dur days.	strm		nextPut: (days byteAt: 1);		nextPut: (days byteAt: 2);		nextPut: (days byteAt: 3);		nextPut: (days byteAt: 4).	strm		nextPut: (dur hours byteAt: 1);		nextPut: (dur minutes byteAt: 1);		nextPut: (dur seconds truncated byteAt: 1).	micros := dur nanoseconds // 1000.	strm		nextPut: (micros byteAt: 1);		nextPut: (micros byteAt: 2);		nextPut: (micros byteAt: 3);		nextPut: (micros byteAt: 4).	"Update the length field now."	length := 11.	micros = 0		ifTrue: [ length := 7.	"no sub-seconds to send"			(dur hours = 0 and: [ dur minutes = 0 and: [ dur seconds = 0 ] ])				ifTrue: [ "no hh:mm:ss to send"					length := 4.					dur days = 0						ifTrue: [ length := 0 ] ] ].	length > 0		ifTrue: [ length := length + 1	"include sign byte" ].	^strm		reset;		nextPut: length;		reset;
		next: length + 1 !

value

	^paramValue! !

!MySQLBindParameter categoriesForMethods!
bindValue:!accessing!public! !
dateTimeBytes!public!writes! !
decimalBytes!public!writes! !
declaredUnsigned:!accessing!public! !
detectParamType!accessing!public! !
doubleBytes!public!writes! !
floatBytes!public!writes! !
initialize!initialize/release!public! !
integerBytes:!public!writes! !
isDeclaredUnsigned!public!testing! !
isInBigIntRange:!public!testing! !
isInLongIntRange:!public!testing! !
isInSmallIntRange:!public!testing! !
isInTinyIntRange:!public!testing! !
isLongData!public!testing! !
isNull!public!testing! !
isRebound!public!testing! !
isUnsigned!public!testing! !
paramType!accessing!public! !
resetReboundFlag!accessing!public! !
sentAsLongData!public!testing! !
sentAsLongData:!accessing!public! !
storableIntegerValueOfSize:!public!writes! !
storeBinaryOn:!accessing!public! !
stringOrBlobBytes!public!writes! !
stringOrBlobBytesRaw!public!writes! !
timeBytes!public!writes! !
value!accessing!public! !
!

!MySQLBindParameter class methodsFor!

listOfSize: count forDescriptors: fields	| params |	params := (1 to: count) collect: [:each |  			(self new 				declaredUnsigned: (fields at: each) isUnsigned; 				yourself)].	^ params	!

new

	^super new initialize!

withValue: aValue	^ self new		bindValue: aValue;		yourself	! !

!MySQLBindParameter class categoriesForMethods!
listOfSize:forDescriptors:!private! !
new!instance creation!public! !
withValue:!private! !
!

