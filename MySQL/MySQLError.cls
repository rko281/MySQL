"Filed out from Dolphin Smalltalk"!

MySQLResult subclass: #MySQLError
	instanceVariableNames: 'fieldCount errNo sqlStateMarker sqlState message'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLError guid: (GUID fromString: '{cc72879c-31a7-49bf-bc11-009d90ae3d6c}')!

MySQLError comment: 'MySQL Error packet'!

!MySQLError categoriesForClass!MySQL-Core-Packet-Results! !

!MySQLError methodsFor!

errNo	^ errNo !

isError	^ true!

message	^ message !

parse	fieldCount := inStream next. "always 0xFF"	errNo := inStream next + (inStream next bitShift: 8).		sqlStateMarker := inStream next asCharacter. "always #"	sqlState := (inStream next: 5) asString .	message := inStream upToEnd asString.!

signalError

	MySQLDriverError signal: message with: self!

sqlState	^ sqlState ! !

!MySQLError categoriesForMethods!
errNo!accessing!public! !
isError!public!testing! !
message!accessing!public! !
parse!parsing!public! !
signalError!private! !
sqlState!accessing!public! !
!

