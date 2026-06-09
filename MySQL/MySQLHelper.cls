"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'seedOne maxValue seedTwo'!

MySQLHelper guid: (GUID fromString: '{934e2348-35e5-48ce-8126-1cfa126a63dd}')!

MySQLHelper comment: 'MySQLHelper class	instanceVariableNames: ''seedOne maxValue seedTwo'''!

!MySQLHelper categoriesForClass!Unclassified! !

!MySQLHelper class methodsFor!

bytesFromHexString: hexString	| strm bytes aByte ii high low hexAlphabet |	(hexString size \\ 2 = 0) ifFalse: [self error: 'Not proper hex encoding'].	strm := ReadStream on: hexString.		bytes := ByteArray new: (hexString size // 2).	hexAlphabet := '0123456789ABCDEF'.	ii := 1.	[strm atEnd] whileFalse: [		high := (hexAlphabet indexOf: (strm next asUppercase)) - 1.		low := (hexAlphabet indexOf: (strm next asUppercase)) - 1.		aByte :=   high * 16 + low.		bytes at: ii put: aByte.		ii := ii + 1].	^ bytes	!

bytesFromSha1Hash: num	| index bytesCount bytes |	index := 0.
	bytesCount := num byteSize min: 20.	bytes := ByteArray new: (bytesCount max: 20).	"gurantee 20 bytes; required for authentication"	20 - bytesCount to: 1 by: -1 do: [ :i | bytes at: (index := index + 1) put: (0 byteAt: 1) ].	"filler 0 from msbyte"	bytesCount to: 1 by: -1 do: [ :i | bytes at: (index := index + 1) put: (num byteAt: i) ].	^ bytes!

decodeLcbFrom: byteStream 	"parse length coded binary"	| first |	first := byteStream next.	(first 		between: 0		and: 250) ifTrue: [ ^ first ].	first = 251 ifTrue: [ ^ -1 ].	"column value is NULL; applicable for row data packet only"	first = 252 ifTrue: [ ^ byteStream next + (byteStream next bitShift: 8) ].	"value of following 2 bytes"	first = 253 ifTrue: 		[ ^ byteStream next + (byteStream next bitShift: 8) + (byteStream next bitShift: 16) ].	"value of following 3 bytes"	first = 254 ifTrue: 		[ ^ byteStream next + (byteStream next bitShift: 8 * 1) + (byteStream next bitShift: 8 * 2) + (byteStream next bitShift: 8 * 3) + (byteStream next bitShift: 8 * 4) + (byteStream next bitShift: 8 * 5) + (byteStream next bitShift: 8 * 6) + (byteStream next bitShift: 8 * 7) ].	"value of following 8 bytes"	^ nil!

decodeLcsFrom: aStream 	"parses length coded string"	| len |	len := self decodeLcbFrom: aStream.	len = -1 ifTrue: [^ nil].	^ aStream next: len.	!

encodeLcb: value on: aStream	value < -1		ifTrue: [ self				error: 'Can not encode value' , value asString , ' to length coded binary' ].	value = -1		ifTrue: [ "represents null column value" ^ aStream nextPut: 251 ].	(value between: 0 and: 250)		ifTrue: [ ^ aStream nextPut: (value byteAt: 1) ].	value <= 65535		ifTrue: [ ^ aStream				nextPut: 252;				nextPut: (value byteAt: 1);				nextPut: (value byteAt: 2) ].	value <= 16777215		ifTrue: [ ^ aStream				nextPut: 253;				nextPut: (value digitAt: 1);				nextPut: (value digitAt: 2);				nextPut: (value digitAt: 3) yourself ].	^ aStream		nextPut: 254;		nextPut: (value digitAt: 1);		nextPut: (value digitAt: 2);		nextPut: (value digitAt: 3);		nextPut: (value digitAt: 4);		nextPut: (value digitAt: 5);		nextPut: (value digitAt: 6);		nextPut: (value digitAt: 7);		nextPut: (value digitAt: 8);		yourself!

encodeLcs: bytes on: aStream	| len |	len := bytes size .	self encodeLcb: len on: aStream .	aStream nextPutAll: bytes .	!

hash: message	"Computes a hash form byte strings,	Returns an array of large positive integers.	Used in pre-4.1 authentication scheme"	"118 {119   register ulong nr=1345345333L, add=7, nr2=0x12345671L;120   ulong tmp;121   const char *password_end= password + password_len;122   for (; password < password_end; password++)123   {124     if (*password == ' ' || *password == '\t')125       continue;                                 /* skip space in password */126     tmp= (ulong) (uchar) *password;127     nr^= (((nr & 63)+add)*tmp)+ (nr << 8);128     nr2+=(nr2 << 8) ^ nr;129     add+=tmp;130   }131   result[0]=nr & (((ulong) 1L << 31) -1L); /* Don't use sign bit (str2int) */;132   result[1]=nr2 & (((ulong) 1L << 31) -1L);133 }"	| nr add nr2 tmp |	nr := 1345345333. add := 7. nr2 := 16r12345671.	message do: [:each |		((each = Character space) or: [each = Character tab]) ifTrue: [] ifFalse: [			tmp := each.			nr := nr bitXor: ((((nr bitAnd: 63) + add) * tmp asInteger) + (nr bitShift: 8)).			nr2 := nr2 + ((nr2 bitShift: 8) bitXor: nr).			add := add + tmp asInteger.		]].		^Array with:(nr bitAnd: ((1 bitShift: 31) - 1)) with: (nr2 bitAnd: ((1 bitShift: 31) - 1))!

hexStringFromBytes: aByteArray	^ aByteArray asHexString asUppercase!

myRandom	seedOne := (seedOne * 3 + seedTwo) \\ maxValue.	seedTwo := (seedOne + seedTwo + 33) \\ maxValue.		^ (seedOne / maxValue) asFloat	!

randomInitWith: seedValue1 and: seedValue2	maxValue := 16r3FFFFFFF.	seedOne := seedValue1 \\ maxValue.	seedTwo := seedValue2 \\ maxValue.!

scramble323: message with: password 	"Scamble the bytestring message with password."	"Return a srambled byte string."	"Used in pre-4.1 authentication scheme"	| hashPass hashMessage outMessage extra byteValue rnd msgUsed |	
	(password isNil or: [password isEmpty]) ifTrue: [^#[]].	msgUsed := message first: (self scramble323MessageLimit min: message size).	hashPass := self hash: password.	hashMessage := self hash: msgUsed. "323 size limit"			self 		randomInitWith: ((hashPass first) bitXor: (hashMessage first))		and: ((hashPass at: 2) bitXor: (hashMessage at: 2)).	outMessage := ByteArray new: msgUsed size.	1 to: outMessage size do: [ :indx | 		rnd := self myRandom.		byteValue := ((rnd * 31) floor + 64) bitAnd: 255.		outMessage at: indx 	put: byteValue].	rnd := self myRandom.	extra := (rnd * 31) floor bitAnd: 255.	1 to: outMessage size		do: 			[ :indx | 			byteValue := (outMessage at: indx) asInteger bitXor: extra.			outMessage at: indx 	put: byteValue ].	^ outMessage	!

scramble323MessageLimit	^ 8	!

secureScramble: seed with: password 	| sha1 hashStage1 hashStage2 hash3 reply |
	(password isNil or: [password isEmpty]) ifTrue: [^#[]].
	sha1 := SecureHashAlgorithm new.	hashStage1 := (sha1 hashMessage: password) asInteger.	hashStage2 := (sha1 hashMessage: (self bytesFromSha1Hash: hashStage1)) asInteger.	hash3 := (sha1 hashMessage: seed asByteArray , (self bytesFromSha1Hash: hashStage2)) asInteger.	reply := self bytesFromSha1Hash: (hashStage1 bitXor: hash3).	^ reply! !

!MySQLHelper class categoriesForMethods!
bytesFromHexString:!public!utilities! !
bytesFromSha1Hash:!public!utilities! !
decodeLcbFrom:!encoding!public! !
decodeLcsFrom:!encoding!public! !
encodeLcb:on:!encoding!public! !
encodeLcs:on:!encoding!public! !
hash:!private! !
hexStringFromBytes:!public!utilities! !
myRandom!private! !
randomInitWith:and:!private! !
scramble323:with:!public! !
scramble323MessageLimit!public!scrambling! !
secureScramble:with:!public!scrambling! !
!

