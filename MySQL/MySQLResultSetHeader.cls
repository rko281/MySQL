"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLResultSetHeader
	instanceVariableNames: 'fieldCount extra'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLResultSetHeader guid: (GUID fromString: '{9e99d17d-2e78-4d45-9c2f-520b5d1515c6}')!

MySQLResultSetHeader comment: 'MySQL Header for a result set '!

!MySQLResultSetHeader categoriesForClass!MySQL-Core-Packet-Results! !

!MySQLResultSetHeader methodsFor!

fieldCount	^ fieldCount !

parse	fieldCount := self decodeLcbFrom: inStream.	"exrta field may appear for some results (like show column)"	inStream atEnd ifFalse: [extra := self decodeLcbFrom: inStream]	! !

!MySQLResultSetHeader categoriesForMethods!
fieldCount!accessing!public! !
parse!parsing!public! !
!

