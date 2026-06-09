"Filed out from Dolphin Smalltalk"!

MySQLComplexResult subclass: #MySQLPrepareResponse
	instanceVariableNames: 'prepareOkay paramDescriptors paramEof columnDescriptors columnEof'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLPrepareResponse guid: (GUID fromString: '{29b571c4-0eb5-4ca6-931a-3f6d9224293d}')!

MySQLPrepareResponse comment: 'Prepare response packet for MySQL'!

!MySQLPrepareResponse categoriesForClass!MySQL-Core-Packet-Results! !

!MySQLPrepareResponse methodsFor!

columnDescriptors	^ columnDescriptors	!

columnDescriptors: fields	columnDescriptors := fields 	!

columnEof: anEof	columnEof := anEof	!

isOkay	^ prepareOkay isOkay 	!

isPrepareResponse	^ true	!

paramDescriptors	^ paramDescriptors	 	!

paramDescriptors: fields	paramDescriptors := fields 	!

paramEof: anEof	paramEof := anEof 	!

prepareOkay	^ prepareOkay	!

prepareOkay: prepOkay	prepareOkay := prepOkay	! !

!MySQLPrepareResponse categoriesForMethods!
columnDescriptors!accessing!public! !
columnDescriptors:!accessing!public! !
columnEof:!accessing!public! !
isOkay!public!testing! !
isPrepareResponse!public!testing! !
paramDescriptors!accessing!public! !
paramDescriptors:!accessing!public! !
paramEof:!accessing!public! !
prepareOkay!accessing!public! !
prepareOkay:!accessing!public! !
!

