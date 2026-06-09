"Filed out from Dolphin Smalltalk"!

MySQLPacket subclass: #MySQL323Scramble
	instanceVariableNames: 'scrambleBuff password'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQL323Scramble guid: (GUID fromString: '{f80d3f15-6481-4caa-a0fb-fb3411fd3338}')!

MySQL323Scramble comment: '323 scramble packet for MySQL'!

!MySQL323Scramble categoriesForClass!MySQL-Core-Packet! !

!MySQL323Scramble methodsFor!

password: pwd	password := pwd	!

scrambleBuff: scramble	scrambleBuff := scramble 	!

write	| scrmbl buffStream |	buffStream := WriteStream on: (ByteArray new: 256).	scrmbl := MySQLHelper scramble323: scrambleBuff with: password .	"Server expects just the scramble, null terminated and nothing else"	buffStream nextPutAll: scrmbl.	buffStream nextPut: 0.	^ buffStream contents 	! !

!MySQL323Scramble categoriesForMethods!
password:!accessing!public! !
scrambleBuff:!accessing!public! !
write!public!writing! !
!

