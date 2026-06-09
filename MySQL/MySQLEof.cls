"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLEof
	instanceVariableNames: 'fieldCount warningCount serverStatus'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLEof guid: (GUID fromString: '{34bf23a6-05f2-4c10-a7bc-4ec69009109d}')!

MySQLEof comment: 'End of File (EOF) received'!

!MySQLEof categoriesForClass!MySQL-Core-Packet! !

!MySQLEof methodsFor!

hasLastRowSent	^ (serverStatus bitAnd: MySQLServerStatus statusLastRowSent) ~= 0	!

hasMoreResults	^ (serverStatus bitAnd: MySQLServerStatus moreResultsExist) ~= 0	!

hasOpenCursor	^ (serverStatus bitAnd: MySQLServerStatus statusCursorExists) ~= 0	!

isEof	^ true!

parse	fieldCount := inStream next.	warningCount := inStream next + (inStream next bitShift: 8).	serverStatus := inStream next + (inStream next bitShift: 8).!

serverStatus	^ serverStatus !

warningCount	^ warningCount ! !

!MySQLEof categoriesForMethods!
hasLastRowSent!public!testing! !
hasMoreResults!public!testing! !
hasOpenCursor!public!testing! !
isEof!public!testing! !
parse!accessing!public! !
serverStatus!accessing!public! !
warningCount!accessing!public! !
!

