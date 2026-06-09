"Filed out from Dolphin Smalltalk"!

TestCase subclass: #MySQLNetworkPacketTest
	instanceVariableNames: 'ioStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLNetworkPacketTest guid: (GUID fromString: '{b95cfd8e-195e-47f8-b36b-8806bc0bab4e}')!

MySQLNetworkPacketTest comment: ''!

!MySQLNetworkPacketTest categoriesForClass!MySQL-Core-Tests-Integration-Network! !

!MySQLNetworkPacketTest methodsFor!

alphabet

	^'abcdefghijklmnopqrstuvwxyz'!

setUp	ioStream := ReadWriteStream on: (ByteArray new).	ioStream reset. !

testMaxLength	self assert: (MySQLNetworkPacket maxLength = 16rFFFFFF).	self assert: (MySQLNetworkPacket new maxLength = 16rFFFFFF)!

testMaxLengthWriteRead	| pktData outPkt inPkt |		"write packet of max possible size"	pktData := ByteArray new: 16rFFFFFF withAll: 16rAA.	outPkt := MySQLNetworkPacket new.	outPkt number: 16rFF; data: pktData; length: pktData size.	outPkt writeTo: ioStream.	"read back"	ioStream reset.		inPkt := MySQLNetworkPacket new.	inPkt readFrom: ioStream.		self assert: (inPkt isOfMaxLength).	self assert: (inPkt number = 16rFF).	self assert: (inPkt data = outPkt data)	!

testMaxPacketLength	| pkt |	pkt := MySQLNetworkPacket new.	self assert: (pkt maxLength = 16rFFFFFF)	!

testPacketWriteRead	| outPkt inPkt pktData |		"Write packet to stream"	pktData := self alphabet asByteArray.	outPkt := MySQLNetworkPacket new.	outPkt length: 26; number: 0; data: pktData.	outPkt writeTo: ioStream.	"Read it back"	ioStream reset.	inPkt := MySQLNetworkPacket new.	inPkt readFrom: ioStream.		self assert: (inPkt length = 26).	self assert: (inPkt number = 0).	self assert: (inPkt data = pktData)	!

testValidateLengthOnWrite	| pktData outPkt |	pktData := self alphabet asByteArray.	outPkt := MySQLNetworkPacket new.	outPkt		length: 25;		number: 0;		data: pktData.	self 		should: [ outPkt writeTo: ioStream ]		raise: Error.	outPkt length: 27.	self 		should: [ outPkt writeTo: ioStream ]		raise: Error.	outPkt length: 26.	self 		shouldnt: [ outPkt writeTo: ioStream ]		raise: Error! !

!MySQLNetworkPacketTest categoriesForMethods!
alphabet!constants!public! !
setUp!private! !
testMaxLength!private! !
testMaxLengthWriteRead!private! !
testMaxPacketLength!private! !
testPacketWriteRead!private! !
testValidateLengthOnWrite!private! !
!

