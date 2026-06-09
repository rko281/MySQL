"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLMockSocket
	instanceVariableNames: 'stream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLMockSocket guid: (GUID fromString: '{0c2c9854-ccb2-4a8e-b42d-6ce54a0c3123}')!

MySQLMockSocket comment: ''!

!MySQLMockSocket categoriesForClass!Kernel-Objects! !

!MySQLMockSocket methodsFor!

close!

isOpen

	^true!

readStream

	^stream!

stream
	^stream!

stream: anObject
	stream := anObject!

writeStream

	^stream! !

!MySQLMockSocket categoriesForMethods!
close!operations!public! !
isOpen!public!testing! !
readStream!accessing!public! !
stream!accessing!private! !
stream:!accessing!private! !
writeStream!accessing!public! !
!

