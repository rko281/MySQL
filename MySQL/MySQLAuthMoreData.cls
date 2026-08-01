"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLAuthMoreData
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLAuthMoreData guid: (GUID fromString: '{e6525de7-03b3-4ff4-98ae-db6f8fe30c4c}')!

MySQLAuthMoreData comment: ''!

!MySQLAuthMoreData categoriesForClass!MySQL-Core-Packet! !

!MySQLAuthMoreData methodsFor!

isAuthenticationComplete

	^value = 3!

isFullAuthenticationRequest

	^value = 4!

parse

	inStream next.
	value := inStream next!

value

	^value! !

!MySQLAuthMoreData categoriesForMethods!
isAuthenticationComplete!public!testing! !
isFullAuthenticationRequest!public!testing! !
parse!parsing!public! !
value!accessing!public! !
!

