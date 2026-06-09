"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLTypes
	instanceVariableNames: ''
	classVariableNames: 'TypeBIT TypeBLOB TypeDATE TypeDATETIME TypeDECIMAL TypeDOUBLE TypeENUM TypeFLOAT TypeGEOMETRY TypeINT24 TypeJSON TypeLONG TypeLONGBLOB TypeLONGLONG TypeMEDIUMBLOB TypeNEWDATE TypeNEWDECIMAL TypeNULL TypeSET TypeSHORT TypeSTRING TypeTIME TypeTIMESTAMP TypeTINY TypeTINYBLOB TypeVARCHAR TypeVARSTRING TypeYEAR'
	poolDictionaries: ''
	classInstanceVariableNames: 'blobTypes dateTimeTypes integerTypes stringTypes realTypes'!

MySQLTypes guid: (GUID fromString: '{8b754205-daf8-48e4-aef1-6dc5b8b4f684}')!

MySQLTypes comment: 'MySQLTypes class	instanceVariableNames: ''blobTypes dateTimeTypes integerTypes stringTypes realTypes'''!

!MySQLTypes categoriesForClass!Unclassified! !

!MySQLTypes class methodsFor!

blobTypes	blobTypes ifNil: [		blobTypes := Array 			with: TypeTINYBLOB with: TypeMEDIUMBLOB with: TypeBLOB with: TypeLONGBLOB ].	^ blobTypes	!

dateTimeTypes	dateTimeTypes ifNil: [		dateTimeTypes := ##({TypeDATE. TypeDATETIME. TypeNEWDATE. TypeTIME. TypeTIMESTAMP. TypeYEAR})		].	^ dateTimeTypes	!

initFieldTypes 	TypeBIT := 16. 	TypeBLOB := 252. 	TypeDATE := 10. 	TypeDATETIME := 12. 	TypeDECIMAL := 0. 	TypeDOUBLE := 5. 	TypeENUM := 247. 	TypeFLOAT := 4. 	TypeGEOMETRY := 255. 	TypeINT24 := 9.	TypeJSON := 245. 	TypeLONG := 3. 	TypeLONGLONG := 8. 	TypeLONGBLOB := 251. 	TypeMEDIUMBLOB := 250. 	TypeNEWDATE := 14. 	TypeNEWDECIMAL := 246. 	TypeNULL := 6. 	TypeSET := 248. 	TypeSHORT := 2. 	TypeSTRING := 254. 	TypeTIME := 11. 	TypeTIMESTAMP := 7. 	TypeTINY := 1. 	TypeTINYBLOB := 249. 	TypeVARCHAR := 15. 	TypeVARSTRING := 253. 	TypeYEAR := 13.!

initialize	"MySQLTypes initialize"	self initFieldTypes!

integerTypes	integerTypes ifNil: [		integerTypes := Array 			with: TypeTINY with: TypeSHORT with: TypeINT24 with: TypeLONG 			with: TypeLONGLONG].	^ integerTypes	!

isBigInt: type	^ type = TypeLONGLONG	!

isLongInt: type	^ type = TypeLONG	!

isMediumInt: type	^ type = TypeINT24	!

isSmallInt: type	^ type = TypeSHORT	!

isTinyInt: type	^ type = TypeTINY	!

realTypes	realTypes ifNil: [		realTypes := Array 			with: TypeFLOAT with: TypeDOUBLE with: TypeDECIMAL with: TypeNEWDECIMAL].	^ realTypes	!

stringTypes	stringTypes ifNil: [		stringTypes := Array with: TypeSTRING with: TypeVARCHAR with: TypeVARSTRING ].	^ stringTypes	!

typeBIT	^ TypeBIT	!

typeBLOB	^ TypeBLOB	!

typeDATE	^ TypeDATE	!

typeDATETIME	^ TypeDATETIME	!

typeDECIMAL	^ TypeDECIMAL	!

typeDOUBLE	^ TypeDOUBLE	!

typeENUM	^ TypeENUM	!

typeFLOAT	^ TypeFLOAT	!

typeGEOMETRY	^ TypeGEOMETRY	!

typeINT24	^ TypeINT24	!

typeJSON	^ TypeJSON	!

typeLONG	^ TypeLONG	!

typeLONGBLOB	^ TypeLONGBLOB	!

typeLONGLONG	^ TypeLONGLONG	!

typeMEDIUMBLOB	^ TypeMEDIUMBLOB	!

typeNEWDATE	^ TypeNEWDATE	!

typeNEWDECIMAL	^ TypeNEWDECIMAL!

typeNULL	^ TypeNULL	!

typeSET	^ TypeSET	!

typeSHORT	^ TypeSHORT	!

typeSTRING	^ TypeSTRING	!

typeTIME	^ TypeTIME	!

typeTIMESTAMP	^ TypeTIMESTAMP	!

typeTINY	^ TypeTINY	!

typeTINYBLOB	^ TypeTINYBLOB	!

typeVARCHAR	^ TypeVARCHAR	!

typeVARSTRING	^ TypeVARSTRING	!

typeYEAR	^ TypeYEAR	! !

!MySQLTypes class categoriesForMethods!
blobTypes!accessing / types / all!public! !
dateTimeTypes!accessing / types / all!public! !
initFieldTypes!private / initialization!public! !
initialize!class initialization!public! !
integerTypes!accessing / types / all!public! !
isBigInt:!public!testing! !
isLongInt:!public!testing! !
isMediumInt:!public!testing! !
isSmallInt:!public!testing! !
isTinyInt:!public!testing! !
realTypes!accessing / types / all!public! !
stringTypes!accessing / types / all!public! !
typeBIT!accessing / types!public! !
typeBLOB!accessing / types!public! !
typeDATE!accessing / types!public! !
typeDATETIME!accessing / types!public! !
typeDECIMAL!accessing / types!public! !
typeDOUBLE!accessing / types!public! !
typeENUM!accessing / types!public! !
typeFLOAT!accessing / types!public! !
typeGEOMETRY!accessing / types!public! !
typeINT24!accessing / types!public! !
typeJSON!accessing / types!public! !
typeLONG!accessing / types!public! !
typeLONGBLOB!accessing / types!public! !
typeLONGLONG!accessing / types!public! !
typeMEDIUMBLOB!accessing / types!public! !
typeNEWDATE!accessing / types!public! !
typeNEWDECIMAL!accessing / types!public! !
typeNULL!accessing / types!public! !
typeSET!accessing / types!public! !
typeSHORT!accessing / types!public! !
typeSTRING!accessing / types!public! !
typeTIME!accessing / types!public! !
typeTIMESTAMP!accessing / types!public! !
typeTINY!accessing / types!public! !
typeTINYBLOB!accessing / types!public! !
typeVARCHAR!accessing / types!public! !
typeVARSTRING!accessing / types!public! !
typeYEAR!accessing / types!public! !
!

