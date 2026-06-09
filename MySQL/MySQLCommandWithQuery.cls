"Filed out from Dolphin Smalltalk"!

MySQLCommandWithResults subclass: #MySQLCommandWithQuery
	instanceVariableNames: 'query'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandWithQuery guid: (GUID fromString: '{d7e7078c-38a0-4546-8e2e-db6b503c8c6a}')!

MySQLCommandWithQuery comment: ''!

!MySQLCommandWithQuery categoriesForClass!MySQL-Core-Command! !

!MySQLCommandWithQuery methodsFor!

commandArg	^ query 	!

queryString: queryString 	query := queryString	! !

!MySQLCommandWithQuery categoriesForMethods!
commandArg!defaults!public! !
queryString:!accessing!public! !
!

