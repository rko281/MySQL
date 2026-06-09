"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQLCommand
	instanceVariableNames: 'command arg'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLCommand guid: (GUID fromString: '{b659f4f5-f2be-46c3-9f55-82c78ead007a}')!

MySQLCommand comment: 'Command packet for MySQL'!

!MySQLCommand categoriesForClass!MySQL-Core-Packet! !

!MySQLCommand methodsFor!

command: cmd arg: text	command := cmd.	arg := text.	!

write	| buffStream |	buffStream := WriteStream on: ByteArray new.	buffStream nextPut: command.	(arg ifNil: ['']) isEmpty ifFalse: [ buffStream nextPutAll: arg asByteArray ].	^ buffStream contents! !

!MySQLCommand categoriesForMethods!
command:arg:!accessing!public! !
write!public!writing! !
!

