"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLServerStatus
	instanceVariableNames: ''
	classVariableNames: 'ServerMoreResultsExist ServerQueryNoGoodIndexUsed ServerQueryNoIndexUsed ServerStatusAutoCommit ServerStatusCursorExists ServerStatusDbDropped ServerStatusInTranssaction ServerStatusLastRowSent ServerStatusNoBackslashEscapes'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLServerStatus guid: (GUID fromString: '{aa02395e-53da-4c15-b98d-c98aca75e024}')!

MySQLServerStatus comment: 'MySQLServerStatus class	instanceVariableNames: '''''!

!MySQLServerStatus categoriesForClass!MySQL-Core-Utilities! !

!MySQLServerStatus class methodsFor!

initFlags	ServerStatusInTranssaction := 1. 		"transaction has started"	ServerStatusAutoCommit := 2. 		"in autocommit mode"	ServerMoreResultsExist := 8.			"multiple result sets for multi-query"	ServerQueryNoGoodIndexUsed := 16.	ServerQueryNoIndexUsed := 32.		"The server was able to fulfill the clients request and opened a	read-only non-scrollable cursor for a query. This flag comes	in reply to COM_STMT_EXECUTE and COM_STMT_FETCH commands."	ServerStatusCursorExists := 64.		"This flag is sent when a read-only cursor is exhausted, in reply to	COM_STMT_FETCH command."	ServerStatusLastRowSent := 128.	ServerStatusDbDropped := 256. 		"a database was dropped"	ServerStatusNoBackslashEscapes := 512.	!

initialize	"self initialize"	self initFlags.	!

moreResultsExist	^ ServerMoreResultsExist	!

statusAutoCommit	^ ServerStatusAutoCommit!

statusCursorExists	^ ServerStatusCursorExists	!

statusInTransaction	^ ServerStatusInTranssaction!

statusLastRowSent	^ ServerStatusLastRowSent	!

statusNoIndexUsed	^ ServerQueryNoIndexUsed! !

!MySQLServerStatus class categoriesForMethods!
initFlags!private! !
initialize!private! !
moreResultsExist!private! !
statusAutoCommit!private! !
statusCursorExists!private! !
statusInTransaction!private! !
statusLastRowSent!private! !
statusNoIndexUsed!private! !
!

