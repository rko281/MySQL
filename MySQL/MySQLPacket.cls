"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLPacket
	instanceVariableNames: 'inStream discriminator'
	classVariableNames: 'CapClientPluginAuth CapCompress CapConnectWithDb CapFoundRows CapIgnoreSigpipe CapIgnoreSpace CapInteractive CapLocalFiles CapLongFlag CapLongPassword CapMultiResults CapMultiStatements CapNoSchema CapOdbc CapProtocol41 CapReserved CapSecureConnection CapSsl CapTransactions'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLPacket guid: (GUID fromString: '{693450e3-99cd-4cf3-bd5c-5da9f0ba70b3}')!

MySQLPacket comment: 'Abtract superclass for network packet exchanged with MySQL'!

!MySQLPacket categoriesForClass!MySQL-Core-Packet! !

!MySQLPacket methodsFor!

decodeLcbFrom: byteStream 	^ MySQLHelper decodeLcbFrom: byteStream 	!

decodeLcsFrom: aStream 	^ MySQLHelper decodeLcsFrom: aStream 	!

encodeLcb: value on: aStream 	^ MySQLHelper encodeLcb: value on: aStream 	!

encodeLcs: bytes on: aStream	MySQLHelper encodeLcs: bytes on: aStream	!

isAuthMoreData

	^discriminator = 1!

isAuthSwitch	^ discriminator = 16rFE!

isEof	^ (discriminator = 16rFE) and: [inStream size < 9]!

isError	^ discriminator = 16rFF!

isOkay	^ discriminator = 16r00!

isOkayOrError	^ self isOkay or: [self isError]!

isPrepareResponse	^ false	!

isResultSet	^ false!

parse	"Default implementation; required for reading a generic (yet unknown) type of packet"	"No parsing here; subclasses implement packet specific parsing"	!

read: buffer	discriminator := buffer first.	inStream := ReadStream on: buffer.	self parse	! !

!MySQLPacket categoriesForMethods!
decodeLcbFrom:!parsing!public! !
decodeLcsFrom:!parsing!public! !
encodeLcb:on:!parsing!public! !
encodeLcs:on:!parsing!public! !
isAuthMoreData!public!testing! !
isAuthSwitch!public!testing! !
isEof!public!testing! !
isError!public!testing! !
isOkay!public!testing! !
isOkayOrError!public!testing! !
isPrepareResponse!public!testing! !
isResultSet!public!testing! !
parse!parsing!public! !
read:!public!reading! !
!

!MySQLPacket class methodsFor!

from: data	^ self new 		read: data	!

initCapabilititesFlags	CapLongPassword := 1.	CapFoundRows := 1 bitShift: 1.	CapLongFlag := 1 bitShift: 2.	CapConnectWithDb := 1 bitShift: 3.	CapNoSchema := 1 bitShift: 4.	CapCompress := 1 bitShift: 5.	CapOdbc := 1 bitShift: 6.	CapLocalFiles := 1 bitShift: 7.	CapIgnoreSpace := 1 bitShift: 8.	CapProtocol41 := 1 bitShift: 9.	CapInteractive := 1 bitShift: 10.	CapSsl := 1 bitShift: 11.	CapIgnoreSigpipe := 1 bitShift: 12.	CapTransactions := 1 bitShift: 13.	CapReserved := 1 bitShift: 14.	CapSecureConnection := 1 bitShift: 15.	CapMultiStatements := 1 bitShift: 16.	CapMultiResults := 1 bitShift: 17.	CapClientPluginAuth := (1 bitShift: 19)!

initialize	"	self initialize	"	self initCapabilititesFlags.!

maxNetPacketLength	^ MySQLNetworkPacket maxLength! !

!MySQLPacket class categoriesForMethods!
from:!instance creation!public! !
initCapabilititesFlags!initialization!public! !
initialize!initialization!public! !
maxNetPacketLength!accessing!public! !
!

