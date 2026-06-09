"Filed out from Dolphin Smalltalk"!

MySQLCommandWithQuery subclass: #MySQLCommandPrepare
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommandPrepare guid: (GUID fromString: '{472ba0c9-7c2f-4078-a56a-2c39682096f5}')!

MySQLCommandPrepare comment: 'MySQL prepare command'!

!MySQLCommandPrepare categoriesForClass!MySQL-Core-Command! !

!MySQLCommandPrepare methodsFor!

commandCode	^ ComStmtPrepare 	!

readColumnDescr	^ MySQLField from: session read.!

readParamDescr	^ MySQLField from: session read.!

readPrepareOkay	| prepOkay params columns paramEof columnEof indx |		prepOkay := MySQLPrepareOkay from: session read.	params := Array new: prepOkay numParams.	columns := Array new: prepOkay numColumns.		prepOkay numParams > 0 ifTrue: [		indx := 1.			[self gotEof] whileFalse: [			params at: indx put: self readParamDescr.			indx := indx + 1 ].		paramEof := self readEof "eof"].	prepOkay numColumns > 0 ifTrue: [			indx := 1.		[self gotEof ] whileFalse: [			columns at: indx put: self readColumnDescr.			indx := indx + 1 ].		columnEof := self readEof "eof"].			^ MySQLPrepareResponse new		prepareOkay: prepOkay;		paramDescriptors: params;		paramEof: paramEof;		columnDescriptors: columns;		columnEof: columnEof;		yourself	!

readResponse	| resp |	resp := MySQLPacket from: session peek.	resp isError ifTrue: [^ MySQLError from: session read].	resp isOkay ifTrue: [^ self readPrepareOkay]! !

!MySQLCommandPrepare categoriesForMethods!
commandCode!defaults!public! !
readColumnDescr!public!reading! !
readParamDescr!public!reading! !
readPrepareOkay!public!reading! !
readResponse!public!reading! !
!

