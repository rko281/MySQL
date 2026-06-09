"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLResult
	instanceVariableNames: 'nextResult'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLResult guid: (GUID fromString: '{310a35cc-2264-459f-a030-8c56090f8e75}')!

MySQLResult comment: 'I am simple logical grouping in the hierarchy that supports multi-results in response to multi-statement queries. The server indicates the presence of more result(set) using the server status flag of specific packets. This may mean that some of my subclasses may point to the next response in the chain if multi-results were sent by the server. Check selector #next and #next: for more.'!

!MySQLResult categoriesForClass!MySQL-Core-Packet-Results! !

!MySQLResult methodsFor!

hasMoreResults	^ false !

nextResult	^ nextResult !

nextResult: aResult	nextResult := aResult 	! !

!MySQLResult categoriesForMethods!
hasMoreResults!public!testing! !
nextResult!accessing!public! !
nextResult:!accessing!public! !
!

