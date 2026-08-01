"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLDriver
	instanceVariableNames: 'netSession handshakeInfo'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLDriver guid: (GUID fromString: '{58894997-7763-4046-a84f-cf3aeeac58b0}')!

MySQLDriver comment: 'Driver class for MySQL'!

!MySQLDriver categoriesForClass!MySQL-Core-Driver! !

!MySQLDriver methodsFor!

assertConnection	self connected ifFalse: [^ MySQLNoConnectionError signal: 'Driver is not connected'].	!

changeUser: connSpec 
	self assertConnection.

	(connSpec isSecureConnection and: [netSession isSecureConnection not]) ifTrue: [MySQLUnsupportedProtocolError signal: 'Cannot switch to secured plugin on unsecured connection'].	
	^(MySQLCommandChangeUser forDriver: self connSpec: connSpec) execute!

commandQueryClass

	^MySQLCommandQuery!

connect: connSpec 
	| handshake resp |
	
	self connected ifTrue: [^ MySQLDriverError signal: 'Driver is already connected'].
	netSession ifNil: [netSession := MySQLNetworkSession new].
	netSession toHost: connSpec host andPort: connSpec port.

	handshake := self readHandshake.
	self writeAuthForHandshake: handshake onConnection: connSpec.

	resp := self peekResponse.
	resp isAuthSwitch 
		ifTrue: [resp := self handleAuthSwitch: connSpec handshake: handshake]
		ifFalse: [resp isAuthMoreData ifTrue: [resp := self handleAuthMoreData: connSpec]]. 

	resp isError ifTrue: [^ MySQLError from: netSession read].
	resp isOkay ifTrue: [
		self keepHandshakeInfo: handshake.
		^ MySQLOkay from: netSession read].

	"Absorb the response"
	netSession read.
	MySQLDriverError signal: 'Unexpected response from server: data is not okay/error/authMoreData/authSwitch'!

connected	^ netSession isNil not and: [netSession connected]	!

disconnect	self assertConnection.	(MySQLCommandQuit  onSession: netSession) execute.	netSession disconnect.	!

errorFromResponse: resp	^ MySQLError from: resp data!

handleAuthMoreData: connSpec	| buffer authMoreData |	buffer := netSession read.	authMoreData := MySQLAuthMoreData from: buffer.
	netSession isSecureConnection ifFalse: [MySQLDriverError signal: 'Secure connection failure'].

	authMoreData isFullAuthenticationRequest 
		ifTrue: [netSession write: (connSpec password asByteArray, #[0])]
		ifFalse: [authMoreData isAuthenticationComplete ifFalse: [MySQLUnsupportedAuthError signal: 'Unknown AuthMoreData packet value' with: authMoreData]].

	^self peekResponse!

handleAuthSwitch: connSpec handshake: handshake	| buffer authSwitch |	buffer := netSession read.
	authSwitch := MySQLAuthSwitch from: buffer.
	authSwitch isCachingSha2
		ifTrue: [netSession isSecureConnection ifFalse: [MySQLUnsupportedAuthError signal: 'Cannot switch to secured plugin on unsecured connection']]
		ifFalse: [authSwitch isNativePassword ifFalse: [MySQLUnsupportedAuthError signal: 'Unsupported AuthSwitch plugin type']].

	authSwitch password: connSpec password.
	netSession write: authSwitch scramble.

	handshake 
		pluginName: authSwitch pluginName;
		scrambleBuff: authSwitch scrambleBuff.

	^self peekResponse!

handshakeInfo	^ handshakeInfo !

isMariaDB

	^'*MariaDB*' match: self versionString!

keepHandshakeInfo: handshake	handshakeInfo := handshake!

majorVersion

	^Integer fromString: (self versionString upTo: $.)!

netSession	^ netSession	!

okayFromResponse: resp	^ MySQLOkay from: resp data!

peekResponse	| buffer resp |		buffer := netSession peek.	resp := MySQLPacket from: buffer.	^ resp	!

ping	self assertConnection.	^ (MySQLCommandPing onSession: netSession) execute!

prepare: queryString	| prepStmt prepResp |	self assertConnection.			prepStmt := MySQLCommandPrepare onSession: netSession.	prepStmt queryString: queryString.	prepResp := prepStmt execute. "error or prepare reponse"		^ prepResp!

query: queryString

	self assertConnection.		
	^(self commandQueryClass onSession: netSession)
		queryString: queryString;
		execute!

readHandshake	| buffer handshake |	buffer := netSession read.	handshake := MySQLHandshake from: buffer.	^handshake !

readResponse	| buffer resp |		buffer := netSession read.	resp := MySQLPacket from: buffer.	^ resp!

versionString

	^(self query: 'select version()') next at: 1!

writeAuthForHandshake: handshake onConnection: connSpec
	| clientAuth |

	clientAuth := 
		handshake clientAuth
			user: connSpec user ;
			password: connSpec password ;
			database: connSpec db ;
			options: connSpec options ;
			yourself.

	connSpec isSecureConnection ifTrue: 
		[netSession write: clientAuth authHeader.
		netSession secureConnection].
	self writePacket: clientAuth!

writePacket: packet	| buffer |		buffer := packet write.	netSession  write: buffer.! !

!MySQLDriver categoriesForMethods!
assertConnection!private!testing! !
changeUser:!operations!public! !
commandQueryClass!accessing!private! !
connect:!operations!public! !
connected!public!testing! !
disconnect!operations!public! !
errorFromResponse:!private! !
handleAuthMoreData:!private! !
handleAuthSwitch:handshake:!private! !
handshakeInfo!private! !
isMariaDB!public!testing! !
keepHandshakeInfo:!private! !
majorVersion!accessing!public! !
netSession!accessing!private! !
okayFromResponse:!private! !
peekResponse!private! !
ping!operations!public! !
prepare:!operations!public! !
query:!operations!public! !
readHandshake!private! !
readResponse!private! !
versionString!accessing!public! !
writeAuthForHandshake:onConnection:!private! !
writePacket:!private! !
!

