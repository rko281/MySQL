"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLField
	instanceVariableNames: 'catalog db table orgTable name orgName charSet type flags default decimals length'
	classVariableNames: 'AutoIncrFlag BinaryFlag BlobFlag EnumFlag MultiKeyFlag NotNullFlag PrimaryKeyFlag SetFlag TimestampFlag UniqueKeyFlag UnsignedFlag ZeroFillFlag'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLField guid: (GUID fromString: '{53845f41-3473-40c3-bfbf-46af0eec5fb5}')!

MySQLField comment: 'Field packet for MySQL'!

!MySQLField categoriesForClass!MySQL-Core-Packet! !

!MySQLField methodsFor!

db	^ db	!

decimals	^ decimals !

isAutoIncrement	^ (flags bitAnd: AutoIncrFlag) = AutoIncrFlag   	!

isNullable	^ (flags bitAnd: NotNullFlag) ~= NotNullFlag  	!

isPrimaryKey	^ (flags bitAnd: PrimaryKeyFlag) = PrimaryKeyFlag  	!

isUnsigned	^ (flags bitAnd: UnsignedFlag) = UnsignedFlag 	!

length	^ length 	!

name	^ name	!

parse
	catalog := Utf8String fromByteArray: (self decodeLcsFrom: inStream).
	db := Utf8String fromByteArray: (self decodeLcsFrom: inStream).
	table := Utf8String fromByteArray: (self decodeLcsFrom: inStream).
	orgTable := Utf8String fromByteArray: (self decodeLcsFrom: inStream).
	name := Utf8String fromByteArray: (self decodeLcsFrom: inStream).
	orgName := Utf8String fromByteArray: (self decodeLcsFrom: inStream).
	inStream next. "filler"
	charSet := inStream next + (inStream next bitShift: 8).
	length := inStream next + (inStream next bitShift: 8) + 
		(inStream next bitShift: 16) + (inStream next bitShift: 24).
	type := inStream next.
	flags := inStream next + (inStream next bitShift: 8).
	decimals := inStream next.
	inStream next; next. "2 filler"
	"The field default only appears for table definitions, not for normal resultsets"
	inStream atEnd ifFalse: [default := self decodeLcbFrom: inStream]!

printOn: aStream	super printOn: aStream.	aStream 		nextPutAll: ' ('; 		nextPutAll: table; 		nextPut: $.; 		nextPutAll: self name; 		nextPutAll: ')'!

readStringOrByteArrayFrom: aStream

	"Handle
	1)	UTF8 encoding - the connection is configured to send String data as UTF8
	2) 	(var)chars/Strings appearing as blobs/ByteArrays:
		https://dev.mysql.com/doc/refman/8.0/en/c-api-data-structures.html
		'To distinguish between binary and nonbinary data for string data types, check whether the charsetnr value is 63. 
		If so, the character set is binary, which indicates binary rather than nonbinary data. 
		This enables you to distinguish BINARY from CHAR, VARBINARY from VARCHAR, and the BLOB types from the TEXT types.'	"

	^charSet = 63
		ifTrue: [MySQLBinaryReader default varBlobFrom: aStream]
		ifFalse: [MySQLBinaryReader default varStringFrom: aStream]!

table	^ table	!

type	^ type	! !

!MySQLField categoriesForMethods!
db!accessing!public! !
decimals!accessing!public! !
isAutoIncrement!public!testing! !
isNullable!public!testing! !
isPrimaryKey!public!testing! !
isUnsigned!public!testing! !
length!accessing!public! !
name!accessing!public! !
parse!accessing!public! !
printOn:!accessing!public! !
readStringOrByteArrayFrom:!accessing!public! !
table!accessing!public! !
type!accessing!public! !
!

!MySQLField class methodsFor!

initBitMasksForFlags	NotNullFlag := 16r0001.	PrimaryKeyFlag := 16r0002.	UniqueKeyFlag := 16r0004.	MultiKeyFlag := 16r0008.	BlobFlag := 16r0010.	UnsignedFlag := 16r0020.	ZeroFillFlag := 16r0040.	BinaryFlag := 16r0080.	EnumFlag := 16r0100.	AutoIncrFlag := 16r0200.	TimestampFlag := 16r0400.	SetFlag := 16r0800.		!

initialize	"self initialize"	self initBitMasksForFlags.! !

!MySQLField class categoriesForMethods!
initBitMasksForFlags!private / initialization!public! !
initialize!initialization!public! !
!

