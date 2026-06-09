"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLCommandBase
	instanceVariableNames: 'session errorDict'
	classVariableNames: 'ComChangeUser ComCreateDb ComDebug ComDropDb ComFieldList ComInitDb ComPing ComQuery ComQuit ComSetOption ComSleep ComStat ComStmtClose ComStmtExecute ComStmtFetch ComStmtPrepare ComStmtReset ComStmtSendLongData'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandBase guid: (GUID fromString: '{72e400e5-f444-4ce5-8b57-ac27a3f25947}')!

MySQLCommandBase comment: 'Abstract superclass for all MySQL commands'!

!MySQLCommandBase categoriesForClass!MySQL-Core-Command! !

!MySQLCommandBase methodsFor!

commandArg	self subclassResponsibility !

commandCode	self subclassResponsibility !

execute

	^session executeCommand: self!

initialize	errorDict := Dictionary new!

prepare	| cmd |	cmd := MySQLCommand new.	cmd command: self commandCode arg: self commandArg.	^ cmd!

readResponse	| resp |	resp := MySQLPacket from: session peek.	resp isError ifTrue: [^ MySQLError from: session read].	resp isOkay ifTrue: [^ MySQLOkay from: session read].	^ resp "Response type unknown at this point"!

send: cmd	| buffer |	buffer := cmd write.	session write: buffer.!

session: ioSession	session := ioSession!

writePacket: packet	| buffer |		buffer := packet write.	session  write: buffer.	! !

!MySQLCommandBase categoriesForMethods!
commandArg!defaults!public! !
commandCode!defaults!public! !
execute!operating!public! !
initialize!initialization!public! !
prepare!operating!public! !
readResponse!operating!public! !
send:!operating!public! !
session:!operating!public! !
writePacket:!operating!public! !
!

!MySQLCommandBase class methodsFor!

initialize	"self initialize"		ComSleep := 16r00.	ComQuit := 16r01.	ComInitDb := 16r02.	ComQuery := 16r03.	ComFieldList := 16r04.	ComStat := 16r09.	ComDebug := 16r0D.	ComPing := 16r0E.	ComChangeUser := 16r11.	ComStmtPrepare := 16r16.	ComStmtExecute := 16r17.	ComStmtSendLongData := 16r18.	ComStmtClose := 16r19.	ComStmtReset := 16r1A.	ComSetOption := 16r1B.	ComStmtFetch := 16r1C.!

new

	^super new initialize!

onSession: ioSession	^ self new session: ioSession	! !

!MySQLCommandBase class categoriesForMethods!
initialize!class initialization!public! !
new!instance creation!public! !
onSession:!instance creation!public! !
!

