"Filed out from Dolphin Smalltalk"!

MySQLRowData subclass: #MySQLQueryRowData
	instanceVariableNames: 'fields'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLQueryRowData guid: (GUID fromString: '{ae145175-4d76-4bd4-be11-d047c6947509}')!

MySQLQueryRowData comment: 'Query row data packet for MySQL'!

!MySQLQueryRowData categoriesForClass!MySQL-Core-Packet-RowData! !

!MySQLQueryRowData methodsFor!

asDictionary
	| dict |
	dict := Dictionary new: fields size.
	fields keysAndValuesDo: [ :i :f | dict at: f name put: (self atIndex: i) ].
	^dict!

at: indx	^ indx isInteger 		ifTrue: [self atIndex: indx]		ifFalse: [ self atFieldNamed: indx ]!

atFieldNamed: aName	^ self atIndex: (self indexOfFieldNamed: aName)!

columnCount: aCount	columnValues := Array new: aCount 	!

fields	^ fields!

fields: anObject	fields := anObject!

indexOfFieldNamed: aName

	"Avoid a full block"
	1 to: fields size do: [ :idx | (fields at: idx) name = aName ifTrue: [ ^idx ] ].	^0!

parse	| indx |	indx := 1.	[inStream atEnd] whileFalse: [| value field |		field := fields at: indx.		value := self readColumnFrom: inStream perDescription: field.		columnValues at: indx put: value.		indx := indx + 1].	!

readColumnFrom: aStream perDescription: columnDescr
	| string stream date time |
	string := (self decodeLcsFrom: aStream) ifNil: [^nil] ifNotNil: [:s | Utf8String fromByteArray: s].
	stream := string readStream.
	columnDescr type  = MySQLTypes.TypeTINY ifTrue: [^Integer readFrom: stream].
	columnDescr type = MySQLTypes.TypeSHORT ifTrue: [^Integer readFrom: stream].
	columnDescr type = MySQLTypes.TypeINT24 ifTrue: [^Integer readFrom: stream].	
	columnDescr type = MySQLTypes.TypeLONG ifTrue: [^Integer readFrom: stream].	
	columnDescr type = MySQLTypes.TypeLONGLONG ifTrue: [^Integer readFrom: stream].

	columnDescr type = MySQLTypes.TypeFLOAT ifTrue: [^string asNumber].
	columnDescr type = MySQLTypes.TypeDOUBLE ifTrue: [^string asNumber].
	columnDescr type = MySQLTypes.TypeDECIMAL ifTrue: [^ScaledDecimal readFrom: stream].
	columnDescr type = MySQLTypes.TypeNEWDECIMAL ifTrue: [^ScaledDecimal readFrom: stream].
	
	columnDescr type = MySQLTypes.TypeSTRING ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeVARCHAR ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeVARSTRING ifTrue: [^string].
	
	columnDescr type = MySQLTypes.TypeTIME ifTrue: [^Time readFrom: stream].
	columnDescr type = MySQLTypes.TypeDATE ifTrue: [^Date readFrom: stream format: 'yyyy-mm-dd'].
	(columnDescr type = MySQLTypes.TypeDATETIME or: [columnDescr type = MySQLTypes.TypeTIMESTAMP or: [columnDescr type = MySQLTypes.TypeNEWDATE]]) ifTrue: 
		[date := Date readFrom: stream format: 'yyyy-mm-dd'.
		stream next.
		time := Time readFrom: stream.
		^columnDescr type = MySQLTypes.TypeTIMESTAMP
			ifTrue: [TimeStamp date: date time: time]
			ifFalse: [DateAndTime fromDate: date time: time]].
	columnDescr type = MySQLTypes.TypeYEAR ifTrue: [^Integer readFrom: stream].
	
	columnDescr type = MySQLTypes.TypeBIT ifTrue: [^Integer readFrom: stream].
	columnDescr type = MySQLTypes.TypeTINYBLOB ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeBLOB ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeMEDIUMBLOB ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeLONGBLOB ifTrue: [^string].
	
	columnDescr type = MySQLTypes.TypeJSON ifTrue: [^STON fromString: string].
		
	columnDescr type = MySQLTypes.TypeNULL ifTrue: [^nil ].
	
	columnDescr type = MySQLTypes.TypeGEOMETRY ifTrue: [^self error: 'not implemented'].
	columnDescr type = MySQLTypes.TypeSET ifTrue: [^self error: 'not implemented'].
	columnDescr type = MySQLTypes.TypeENUM ifTrue: [^self error: 'not implemented'].

	^self error: 'Unknown mysql type'! !

!MySQLQueryRowData categoriesForMethods!
asDictionary!accessing!public! !
at:!accessing!public! !
atFieldNamed:!accessing!public! !
columnCount:!accessing!public! !
fields!accessing!public! !
fields:!accessing!public! !
indexOfFieldNamed:!accessing!public! !
parse!parsing!public! !
readColumnFrom:perDescription:!parsing!public! !
!

