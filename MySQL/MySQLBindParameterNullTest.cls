"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLBindParameterNullTest
	instanceVariableNames: 'theParam'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLBindParameterNullTest guid: (GUID fromString: '{41122976-2809-459e-90de-17ded68d5d01}')!

MySQLBindParameterNullTest comment: ''!

!MySQLBindParameterNullTest categoriesForClass!MySQL-Core-Tests-Utilities! !

!MySQLBindParameterNullTest methodsFor!

setUp	theParam := MySQLBindParameter new.	!

testNullParamBinaryWrite	"binding a nil param		- should produce an empty string in binary protocol"	ByteArray streamContents: [:strm |		theParam storeBinaryOn: strm.		self 			should: [strm contents isEmpty]			description: 'binding nil should produce an empty string in binary protocol']		!

testNullParamBind	"binding a nil value		- should set the param type to NULL"	theParam bindValue: nil.	self 		should: [theParam detectParamType = MySQLTypes.TypeNULL] 		description: 'binding nil should set param type to NULL'.		!

testNullParamTest	"binding a nil value		- should return true when tested for type NULL	"	theParam bindValue: nil.	self 		should: [theParam isNull] 		description: 'binding nil should set type to NULL'		! !

!MySQLBindParameterNullTest categoriesForMethods!
setUp!public!running! !
testNullParamBinaryWrite!public!tests! !
testNullParamBind!public!tests! !
testNullParamTest!public!tests! !
!

