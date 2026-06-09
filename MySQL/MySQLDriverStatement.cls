"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLDriverStatement
	instanceVariableNames: 'driver typeMapResults stmtId params rsContext cursoredFetch fetchSize needsReset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLDriverStatement guid: (GUID fromString: '{37720e3f-439c-475d-90e6-5caff4a86c3a}')!

MySQLDriverStatement comment: 'MySQL driver statement'!

!MySQLDriverStatement categoriesForClass!MySQL-Core-Driver! !

!MySQLDriverStatement methodsFor!

addBinding: anObject		params add: (MySQLBindParameter new bindValue: anObject)!

close	| cmd |	cmd := MySQLCommandCloseStatement onSession: driver netSession.	cmd statementId: stmtId.	^ cmd execute.	!

cursoredFetch	^ cursoredFetch!

cursoredFetch: aBoolean 	cursoredFetch := aBoolean!

driver: aDriver	driver := aDriver	!

error: aString

	needsReset := true.
	MySQLStatementError signal: aString with: self!

execute
	| cmd resp |

	needsReset ifTrue: 
		[resp := self resetStmt.
		resp isError ifTrue: [ ^ resp ]].

	self sendLongData.
	cmd := self executeCommandClass onSession: driver netSession.
	cmd
		cursoredFetch: cursoredFetch;
		mapResultsToNativeTypes: typeMapResults;
		statementId: stmtId;
		params: params asArray.
	resp := cmd execute.
	resp isError ifTrue: 
		[ needsReset := true.
		resp signalError ].
	
	rsContext := resp isResultSet 
		ifTrue: [ 
			needsReset := resp hasOpenCursor.
			resp statement: self.
			resp ]
		ifFalse: [ nil ].
	^ resp!

executeCommandClass
	^MySQLCommandExecute!

fetchCommandClass
	^MySQLCommandFetch!

fetchRows

	self fetchRows: self fetchSize!

fetchRows: num
	| cmd res |
	cmd := self fetchCommandClass onSession: driver netSession.
	cmd
		resultSetContext: rsContext;
		statementId: stmtId;
		numRows: num.
	res := cmd execute.
	rsContext hasLastRowSent ifTrue: [needsReset := false].
	^res!

fetchSize		^ fetchSize!

fetchSize: anInteger 		self cursoredFetch: true.	fetchSize := anInteger!

initialize	params := OrderedCollection new.	cursoredFetch := false.	typeMapResults := true.
	needsReset := false!

needsReset

	"Statements only need resetting prior to (re)execution if:
	 - long data was sent for the previous execution (reset clears this)
	 - any previous results set was not fully consumed (reset closes this)
	 - an error has occurred (to ensure any potential erroneous state is cleared)"

	^needsReset!

needsReset: aBoolean

	needsReset := aBoolean!

params: bindParams	params := bindParams	!

resetStmt

	| cmd resp |

	cmd := MySQLCommandResetStatement onSession: driver netSession.
	cmd statementId: stmtId.
	resp := cmd execute.
	resp isOkay ifTrue: [needsReset := false].
	^resp!

sendLongData		params keysAndValuesDo: 
		[ :indx :aParam |		aParam isLongData ifTrue: 			[self sendLongParam: aParam withNum: indx - 1. "first param index is 0"			aParam sentAsLongData: true "mark that it has been sent as long data"]]!

sendLongParam: aParam withNum: paramNum
	| dataStream cmd |
	needsReset := true.

	dataStream := ReadStream on: aParam stringOrBlobBytesRaw.
	cmd := MySQLCommandLongData onSession: driver netSession.
	cmd 
		paramNum: paramNum;
		statementId: stmtId.
	[cmd 
		dataBytes: (dataStream nextAvailable: 1048576); "1 MB; default"		execute.
	dataStream atEnd] whileFalse!

stmtId: anId	stmtId := anId	!

typeMapResults: aBoolean	typeMapResults := aBoolean	! !

!MySQLDriverStatement categoriesForMethods!
addBinding:!accessing!public! !
close!accessing!public! !
cursoredFetch!accessing!public! !
cursoredFetch:!accessing!public! !
driver:!accessing!public! !
error:!accessing!public! !
execute!accessing!public! !
executeCommandClass!accessing!public! !
fetchCommandClass!accessing!public! !
fetchRows!accessing!public! !
fetchRows:!accessing!public! !
fetchSize!accessing!public! !
fetchSize:!cursor!public! !
initialize!initialize/release!public! !
needsReset!public!testing! !
needsReset:!accessing!public! !
params:!accessing!public! !
resetStmt!accessing!public! !
sendLongData!private! !
sendLongParam:withNum:!private! !
stmtId:!accessing!public! !
typeMapResults:!accessing!public! !
!

!MySQLDriverStatement class methodsFor!

new

	^super new initialize!

onConnection: aDriver	^ self new		driver: aDriver;		yourself		! !

!MySQLDriverStatement class categoriesForMethods!
new!instance creation!public! !
onConnection:!private! !
!

