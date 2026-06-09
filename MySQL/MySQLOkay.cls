"Filed out from Dolphin Smalltalk"!

MySQLResult subclass: #MySQLOkay
	instanceVariableNames: 'message fieldCount affectedRows insertId warningCount serverStatus'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLOkay guid: (GUID fromString: '{e114b640-f4e0-4b09-a34d-a85813c6c2ec}')!

MySQLOkay comment: 'MySQL Error packet'!

!MySQLOkay categoriesForClass!MySQL-Core-Packet-Results! !

!MySQLOkay methodsFor!

affectedRows	^ affectedRows !

hasMoreResults	^ (serverStatus bitAnd: MySQLServerStatus moreResultsExist) ~= 0	!

insertId	^ insertId !

inTransaction	| autoCommit inTx |	autoCommit := (serverStatus bitAnd: MySQLServerStatus statusInTransaction) ~= 0.	inTx := (serverStatus bitAnd: MySQLServerStatus statusInTransaction) ~= 0.	^ autoCommit and: inTx	!

isOkay	^ true!

message	^ message !

parse 	fieldCount := self decodeLcbFrom: inStream . "always 0"	affectedRows := self decodeLcbFrom: inStream .	insertId := self decodeLcbFrom: inStream .	serverStatus := inStream next + (inStream next bitShift: 8) .	warningCount := inStream next + (inStream next bitShift: 8) .	message := Utf8String fromByteArray: (inStream upToEnd)!

serverStatus	^ serverStatus !

warningCount	^ warningCount ! !

!MySQLOkay categoriesForMethods!
affectedRows!accessing!public! !
hasMoreResults!public!testing! !
insertId!accessing!public! !
inTransaction!accessing!public! !
isOkay!public!testing! !
message!accessing!public! !
parse!parsing!public! !
serverStatus!accessing!public! !
warningCount!accessing!public! !
!

