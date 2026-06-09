"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLNetworkPacket
	instanceVariableNames: 'length number data'
	classVariableNames: 'MaxPacketLength'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLNetworkPacket guid: (GUID fromString: '{76b472fb-c6d3-4db8-9750-f16f16e74ac4}')!

MySQLNetworkPacket comment: 'A MySQL Network packet'!

!MySQLNetworkPacket categoriesForClass!MySQL-Core-Network! !

!MySQLNetworkPacket methodsFor!

data	^ data!

data: buffer "should be ByteArray"	data := buffer!

isOfMaxLength	^ length = MaxPacketLength!

length	^ length !

length: size	length := size!

maxLength	^ MaxPacketLength!

number	^ number!

number: num	number := num!

readFrom: aStream	length := aStream next + (aStream next << 8) + (aStream next << 16).	number := aStream next.	data := aStream next: length.!

writeTo: aStream	length = data size		ifFalse: [ self error: 'Mismatch between packet length and data size' ].	aStream		nextPut: (length byteAt: 1);		nextPut: (length byteAt: 2);		nextPut: (length byteAt: 3);
		nextPut: (number byteAt: 1);
		nextPutAll: data; 
		flush! !

!MySQLNetworkPacket categoriesForMethods!
data!accessing!public! !
data:!accessing!public! !
isOfMaxLength!public!testing! !
length!accessing!public! !
length:!accessing!public! !
maxLength!accessing!public! !
number!accessing!public! !
number:!accessing!public! !
readFrom:!public!reading! !
writeTo:!public!writing! !
!

!MySQLNetworkPacket class methodsFor!

initialize 	MaxPacketLength := 16rFFFFFF!

maxLength	^ MaxPacketLength! !

!MySQLNetworkPacket class categoriesForMethods!
initialize!class initialization!public! !
maxLength!accessing!public! !
!

