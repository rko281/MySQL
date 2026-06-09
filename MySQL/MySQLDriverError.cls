"Filed out from Dolphin Smalltalk"!

Error subclass: #MySQLDriverError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLDriverError guid: (GUID fromString: '{70bcee14-c6d3-44b8-b115-d3d7d8ed5cb8}')!

MySQLDriverError comment: 'MySQLDriverError subclass: #MySQLBindError	instanceVariableNames: ''''	classVariableNames: ''''	package: ''MySQL-Core-Exception'''!

!MySQLDriverError categoriesForClass!MySQL-Core-Exception! !

!MySQLDriverError methodsFor!

response

	"If the receiver was signalled from an error response, the response is in the tag"

	^self tag! !

!MySQLDriverError categoriesForMethods!
response!accessing!public! !
!

