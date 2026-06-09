"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLBinaryReader
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'defaultInstance'!

MySQLBinaryReader guid: (GUID fromString: '{79452201-8f3e-4b7d-99de-ecd7f59f28da}')!

MySQLBinaryReader comment: 'Binary reader for MySQL'!

!MySQLBinaryReader categoriesForClass!Unclassified! !

!MySQLBinaryReader methodsFor!

bigIntFrom: aStream	"^ aStream next + (aStream next << 8) + (aStream next << 16) + (aStream next << 24) + 		(aStream next << 32) + (aStream next << 40) + (aStream next << 48) + (aStream next << 56)"
	| bigInt |
	bigInt := aStream collection qwordAtOffset: aStream position.
	aStream skip: 8.
	^bigInt!

dateFrom: aStream "ByteStream"	"Ref: libmysql.c >> read_binary_date"	| len year month day |		len := aStream next.	len = 0 ifTrue: [^ nil].	year := month := day := 0.	year := self smallIntFrom: aStream.	month := self tinyIntFrom: aStream.	day := self tinyIntFrom: aStream.	aStream next: (len - 4). "ignore rest of fields even if present"	^ Date year: year month: month day: day	!

dateTimeFrom: aStream "ByteStream"	"Ref: libmysql.c >> read_binary_datetime"	"length(1) + year(2) + month(1) + day(1) + hh(1) + mm(1) + ss(1) + micoSeconds(4)"		| length year month day hh mm ss ns |	length := aStream next.	length = 0 ifTrue: [^ nil].		year := self smallIntFrom: aStream.	month := self tinyIntFrom: aStream.	day := self tinyIntFrom: aStream.		hh := mm:= ss := ns := 0.	length > 4 ifTrue: [		hh := self tinyIntFrom: aStream.		mm := self tinyIntFrom: aStream.		ss := self tinyIntFrom: aStream.].		length > 7 ifTrue: [ns := (self longIntFrom: aStream) * 1000].	^ DateAndTime 		year: year month: month day: day 		hour: hh minute: mm second: (ss + (ns / 1e9)) offset: Locale timeZoneInformation offset!

decimalWithScale: scale from: aStream
	
	| integerPart number fractionPart streamScale byte isNegative stream |

	stream := (MySQLHelper decodeLcsFrom: aStream) readStream.
	integerPart := 0.
	isNegative := stream peekFor: ##($- asciiValue).
	[stream atEnd or: [(byte := stream next) == ##($. asciiValue)]]
		whileFalse: [integerPart := integerPart * 10 + (byte - ##($0 asciiValue))].
	fractionPart := 0.
	streamScale := 0.
	[stream atEnd] whileFalse: 
			[byte := stream next.
			fractionPart := fractionPart * 10 + (byte - ##($0 asciiValue)).
			streamScale := streamScale + 1].
	number := fractionPart / streamScale exp10 + integerPart.
	isNegative ifTrue: [number := number negated].
	^ScaledDecimal newFromNumber: number scale: scale
	!

doubleFrom: aStream	^(aStream next: 8) doubleAtOffset: 0!

floatFrom: aStream
	^(aStream next: 4) floatAtOffset: 0!

longIntFrom: aStream"	^ aStream next + (aStream next << 8) + (aStream next << 16) + (aStream next << 24)"

	| longInt |
	longInt := aStream collection dwordAtOffset: aStream position.
	aStream skip: 4.
	^longInt!

mediumIntFrom: aStream	"int24 is sent as 4 bytes int"	"Ref: libmysql.c >> fetch_result_with_conversion()"
	| medInt |
	medInt := aStream collection dwordAtOffset: aStream position.
	aStream skip: 4.
	^medInt!

smallIntFrom: aStream	^ aStream next + (aStream next << 8) 		!

timeFrom: aStream 	"ByteStream"	"length(1) + sign(1) + days(4) + hh(1) + mm(1) + ss(1) + subSeconds(4)"	"According to the mySQL docs, it deos not store the fraction part of the seconds."	| length sign days hh mm ss timeDuration timeOfDay ns |	length := aStream next.	length = 0 ifTrue: [ ^ Time fromSeconds: 0 ].	sign := aStream next = 0 		ifTrue: [ 1 ]		ifFalse: [ 1 negated ].	days := self longIntFrom: aStream.	hh := mm := ss := ns := 0.	length > 5 ifTrue: 		[ hh := self tinyIntFrom: aStream.		mm := self tinyIntFrom: aStream.		ss := self tinyIntFrom: aStream ].	length > 8 ifTrue: [ ns := 1000 * (self longIntFrom: aStream) ].	timeDuration := Duration 		days: days		hours: hh		minutes: mm		seconds: (ss + (ns / 1e9)).	timeOfDay := Time 		hours: hh		minutes: mm		seconds: (ss + (ns / 1e9)).	sign < 0 ifTrue: [ ^ timeDuration negated ].	days > 0 		ifTrue: [ ^ timeDuration ]		ifFalse: [ ^ timeOfDay ]!

timeStampFrom: aStream "ByteStream"	^ self dateTimeFrom: aStream.	!

tinyIntFrom: aStream	^ aStream next 		!

varBlobFrom: aStream	^ MySQLHelper decodeLcsFrom: aStream 		!

varStringFrom: aStream

	| len string |
	len := MySQLHelper decodeLcbFrom: aStream.
	len = -1 ifTrue: [^ nil].

	string := Utf8String new: len.
	1 to: len do: [ :idx | string basicAt: idx put: aStream next].
	^string!

yearFrom: aStream "ByteStream"	^ self smallIntFrom: aStream		! !

!MySQLBinaryReader categoriesForMethods!
bigIntFrom:!integer!public! !
dateFrom:!public!time! !
dateTimeFrom:!public!time! !
decimalWithScale:from:!public!real! !
doubleFrom:!public!real! !
floatFrom:!public!real! !
longIntFrom:!integer!public! !
mediumIntFrom:!integer!public! !
smallIntFrom:!integer!public! !
timeFrom:!public!time! !
timeStampFrom:!public!time! !
tinyIntFrom:!integer!public! !
varBlobFrom:!blob!public! !
varStringFrom:!public!string! !
yearFrom:!public!time! !
!

!MySQLBinaryReader class methodsFor!

default	defaultInstance isNil ifTrue: [ defaultInstance := self new ].	^ defaultInstance! !

!MySQLBinaryReader class categoriesForMethods!
default!private! !
!

