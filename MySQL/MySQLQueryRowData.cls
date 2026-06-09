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
	| string |
	string := (self decodeLcsFrom: aStream) ifNil: [^self] ifNotNil: [:s | Utf8String fromByteArray: s].
	columnDescr type  = MySQLTypes.TypeTINY ifTrue: [^Integer readFrom: string readStream].
	columnDescr type = MySQLTypes.TypeSHORT ifTrue: [^Integer readFrom: string readStream].
	columnDescr type = MySQLTypes.TypeINT24 ifTrue: [^Integer readFrom: string readStream].	
	columnDescr type = MySQLTypes.TypeLONG ifTrue: [^Integer readFrom: string readStream].	
	columnDescr type = MySQLTypes.TypeLONGLONG ifTrue: [^Integer readFrom: string readStream].

	columnDescr type = MySQLTypes.TypeFLOAT ifTrue: [^string asNumber].
	columnDescr type = MySQLTypes.TypeDOUBLE ifTrue: [^string asNumber].
	columnDescr type = MySQLTypes.TypeDECIMAL ifTrue: [^ScaledDecimal readFrom: string readStream].
	columnDescr type = MySQLTypes.TypeNEWDECIMAL ifTrue: [^ScaledDecimal readFrom: string readStream].
	
	columnDescr type = MySQLTypes.TypeSTRING ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeVARCHAR ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeVARSTRING ifTrue: [^string].
	
	columnDescr type = MySQLTypes.TypeTIME ifTrue: [^Time fromString: string].
	columnDescr type = MySQLTypes.TypeDATE ifTrue: [^Date fromString: string].
	columnDescr type = MySQLTypes.TypeDATETIME ifTrue: [^DateAndTime fromString: string].
	columnDescr type = MySQLTypes.TypeTIMESTAMP ifTrue: [^DateAndTime fromString: string].
	columnDescr type = MySQLTypes.TypeYEAR ifTrue: [^string asInteger].
	columnDescr type = MySQLTypes.TypeNEWDATE ifTrue: [^DateAndTime fromString: string].
	
	columnDescr type = MySQLTypes.TypeBIT ifTrue: [^Integer readFrom: string readStream].
	columnDescr type = MySQLTypes.TypeTINYBLOB ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeBLOB ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeMEDIUMBLOB ifTrue: [^string].
	columnDescr type = MySQLTypes.TypeLONGBLOB ifTrue: [^string].
	
	columnDescr type = MySQLTypes.TypeJSON ifTrue: [^STON fromString: string].
		
	columnDescr type = MySQLTypes.TypeNULL ifTrue: [^self ].
	
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

