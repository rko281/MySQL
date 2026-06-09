"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLPrepareOkay
	instanceVariableNames: 'warningCount numColumns numParams stmtId'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLPrepareOkay guid: (GUID fromString: '{80df0084-68cb-456e-83ca-28ae25c6958c}')!

MySQLPrepareOkay comment: 'Prepare okay packet for MySQL'!

!MySQLPrepareOkay categoriesForClass!MySQL-Core-Packet! !

!MySQLPrepareOkay methodsFor!

isOkay	^ true	!

numColumns	^ numColumns!

numParams	^ numParams!

parse 	inStream next.	"always 0, marker for oaky pakcet"	stmtId := inStream next + (inStream next bitShift: 8) + 			(inStream next bitShift: 16) + (inStream next bitShift: 24).	numColumns := inStream next + (inStream next bitShift: 8).	numParams := inStream next + (inStream next bitShift: 8).	inStream next.	"filler, always 0"	warningCount := inStream next + (inStream next bitShift: 8)	!

stmtHandlerId	^ stmtId!

warningCount	^ warningCount	! !

!MySQLPrepareOkay categoriesForMethods!
isOkay!public!testing! !
numColumns!accessing!public! !
numParams!accessing!public! !
parse!parsing!public! !
stmtHandlerId!accessing!public! !
warningCount!accessing!public! !
!

