"Filed out from Dolphin Smalltalk"!

MySQLRowData subclass: #MySQLBinaryRowData
	instanceVariableNames: 'header nullBitMap columnDescriptors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBinaryRowData guid: (GUID fromString: '{b3b6339c-9ed7-449d-9322-8caadc33bf8f}')!

MySQLBinaryRowData comment: 'Common superclass for MySQL binary row data'!

!MySQLBinaryRowData categoriesForClass!MySQL-Core-Packet-RowData! !

!MySQLBinaryRowData methodsFor!

columnDescriptors: fieldList	columnDescriptors := fieldList 	!

isColumnNullAt: index	| byteIndex bitsToShift bitMask |	byteIndex := index + 9 // 8.	bitsToShift := index + 9 \\ 8.	bitMask := 1 << bitsToShift.		^ ((nullBitMap at: byteIndex) bitAnd: bitMask) ~= 0		!

nullBitMap: byteArray "primarily for testing"	nullBitMap := byteArray 	!

parse

	header := inStream next.	"always 0"
	nullBitMap := inStream next: (columnDescriptors size + 9) // 8.
	columnValues := Array new: columnDescriptors size.
	columnDescriptors keysAndValuesDo:
		[ :indx :colDescr |
		columnValues at: indx put: 
			((self isColumnNullAt: indx) 
				ifTrue: [ nil ] "null"
				ifFalse: [ self readColumnFrom: inStream perDescription: colDescr ])	"non-null; read from stream per col description" ]!

readColumnFrom: aStream perDescription: columnDescr
	| reader type value mask |

	reader := MySQLBinaryReader default.
	type := columnDescr type.
	type = MySQLTypes.TypeTINY ifTrue: [mask := 16r80. value := reader tinyIntFrom: aStream].
	type = MySQLTypes.TypeSHORT ifTrue: [mask := 16r8000. value := reader smallIntFrom: aStream].
	type = MySQLTypes.TypeINT24 ifTrue: [mask := 16r80000000. value := reader mediumIntFrom: aStream].	
	type = MySQLTypes.TypeLONG ifTrue: [mask := 16r80000000. value := reader longIntFrom: aStream].	
	type = MySQLTypes.TypeLONGLONG ifTrue: [mask := 16r8000000000000000. value := reader bigIntFrom: aStream].

	value notNil ifTrue: 
		[^(columnDescr isUnsigned or: [(value bitAnd: mask) = 0]) 
			ifTrue: [value]
			ifFalse: [value - (mask << 1) "if msb is set and field is signed, then negative"]].
	
	(type = MySQLTypes.TypeSTRING or: [type = MySQLTypes.TypeVARCHAR or: [type = MySQLTypes.TypeVARSTRING]]) ifTrue: [^columnDescr readStringOrByteArrayFrom: aStream].

	type = MySQLTypes.TypeFLOAT ifTrue: [^reader floatFrom: aStream].
	type = MySQLTypes.TypeDOUBLE ifTrue: [^reader doubleFrom: aStream].
	(type = MySQLTypes.TypeDECIMAL or: [type = MySQLTypes.TypeNEWDECIMAL]) ifTrue: [^reader decimalWithScale: columnDescr decimals from: aStream].
	
	type = MySQLTypes.TypeTIME ifTrue: [^reader timeFrom: aStream].
	type = MySQLTypes.TypeDATE ifTrue: [^reader dateFrom: aStream].
	type = MySQLTypes.TypeDATETIME ifTrue: [^reader dateTimeFrom: aStream].
	type = MySQLTypes.TypeTIMESTAMP ifTrue: [^reader dateTimeTimezoneAwareFrom: aStream].
	type = MySQLTypes.TypeYEAR ifTrue: [^reader yearFrom: aStream].
	
	(type = MySQLTypes.TypeTINYBLOB or: [type = MySQLTypes.TypeBLOB or: [type = MySQLTypes.TypeMEDIUMBLOB or: [type = MySQLTypes.TypeLONGBLOB]]]) ifTrue: [^columnDescr readStringOrByteArrayFrom: aStream].

	(type = MySQLTypes.TypeNULL or: [type = MySQLTypes.TypeGEOMETRY or: [type = MySQLTypes.TypeSET or: [type = MySQLTypes.TypeENUM or: [type = MySQLTypes.TypeBIT]]]]) ifTrue: [self error: 'not yet implemented'].
	self error: 'Unknown mysql type'! !

!MySQLBinaryRowData categoriesForMethods!
columnDescriptors:!accessing!public! !
isColumnNullAt:!public!testing! !
nullBitMap:!accessing!public! !
parse!parsing!public!reading! !
readColumnFrom:perDescription:!accessing!public! !
!

