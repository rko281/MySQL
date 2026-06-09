"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLNetworkSessionTest
	instanceVariableNames: 'session ioStream maxLen'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLNetworkSessionTest guid: (GUID fromString: '{ecb0298f-2fab-44ef-80cb-57adf7638636}')!

MySQLNetworkSessionTest comment: ''!

!MySQLNetworkSessionTest categoriesForClass!MySQL-Core-Tests-Integration-Network! !

!MySQLNetworkSessionTest methodsFor!

initialize	maxLen := MySQLNetworkPacket maxLength.!

maxLen	^maxLen !

setUp	session := MySQLNetworkSession new.	ioStream := ReadWriteStream on: (ByteArray new). "test stream"	ioStream reset. 	session socket: (MySQLMockSocket new stream: ioStream "inject test stream instead of using socket stream")!

testBigSizeReadWrite	| pktData |		pktData := ByteArray new: self maxLen * 2 + (self maxLen >> 8) withAll: 16rAA.	self verifyWriteFollowedByReadForData: pktData	!

testLessThanMaxSizeReadWrite	| pktData |		pktData := ByteArray new: self maxLen >> 8 withAll: 16rAA.	self verifyWriteFollowedByReadForData: pktData	!

testMaxSizeReadWrite	| pktData |		pktData := ByteArray new: self maxLen withAll: 16rAA.	self verifyWriteFollowedByReadForData: pktData	!

testSequenceNumbering	self assert: (session getSequence = 0) description: '0 right after creation'.	self assert: (session validateSequence: 0).	session updateSequence.	self assert: (session getSequence = 1).	self assert: (session validateSequence: 1).	255 timesRepeat: [session updateSequence].	self assert: (session getSequence = 0) description: 'Modulo 256'.	self assert: (session validateSequence: 0).	10 timesRepeat: [session updateSequence].	self assert: (session getSequence = 10).	self assert: (session validateSequence: 10).		session resetSequence.	self assert: (session getSequence = 0).	self assert: (session validateSequence: 0) 	!

verifyWriteFollowedByReadForData: writeData	| readData |	session write: writeData.	ioStream reset.	session resetSequence.	readData := session readPacketData.	self assert: (readData size = writeData size).	self assert: (readData = writeData)	! !

!MySQLNetworkSessionTest categoriesForMethods!
initialize!initialization!public! !
maxLen!accessing!public! !
setUp!public!running! !
testBigSizeReadWrite!public!tests! !
testLessThanMaxSizeReadWrite!public!tests! !
testMaxSizeReadWrite!public!tests! !
testSequenceNumbering!public!tests! !
verifyWriteFollowedByReadForData:!private! !
!

!MySQLNetworkSessionTest class methodsFor!

new

	^super new initialize! !

!MySQLNetworkSessionTest class categoriesForMethods!
new!public! !
!

