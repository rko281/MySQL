"Filed out from Dolphin Smalltalk"!

MySQLClientAuth subclass: #MySQLSha2ClientAuth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLSha2ClientAuth guid: (GUID fromString: '{ae7ef8bc-dac4-46f2-ab83-0d8c20063df7}')!

MySQLSha2ClientAuth comment: ''!

!MySQLSha2ClientAuth categoriesForClass!MySQL-Core-Packet! !

!MySQLSha2ClientAuth methodsFor!

initialize	super initialize.	clientCaps := clientCaps + CapClientPluginAuth!

scramble

	^MySQLHelper secureScramble256: scrambleBuff , scrambleBuffMore with: password !

writeOn: buffStream

	super writeOn: buffStream.

	buffStream
		nextPutAll: self class pluginName asByteArray;
		nextPut: 0! !

!MySQLSha2ClientAuth categoriesForMethods!
initialize!initialization!public! !
scramble!public!scrambling! !
writeOn:!private!writing! !
!

!MySQLSha2ClientAuth class methodsFor!

pluginName

	^'caching_sha2_password'! !

!MySQLSha2ClientAuth class categoriesForMethods!
pluginName!constants!public! !
!

