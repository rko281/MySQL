"Filed out from Dolphin Smalltalk"!

Object subclass: #MySQLDriverSpec
	instanceVariableNames: 'host port user password database options'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLDriverSpec guid: (GUID fromString: '{e52f0cc8-d0a2-452e-8d95-8e1011b603cf}')!

MySQLDriverSpec comment: 'Driver specification'!

!MySQLDriverSpec categoriesForClass!MySQL-Core-Driver! !

!MySQLDriverSpec methodsFor!

database: dbName	database := dbName!

db	^ database!

db: dbName	database := dbName!

host	^ host!

host: server	host := server!

options: driverOptions	options := driverOptions!

password	^ password!

password: userPassword	password := userPassword!

port	^ port ifNil: [ port := 3306 ]!

port: serverPort	port := serverPort!

user	^ user!

user: userName	user := userName! !

!MySQLDriverSpec categoriesForMethods!
database:!accessing!public! !
db!accessing!public! !
db:!accessing!public! !
host!accessing!public! !
host:!accessing!public! !
options:!accessing!public! !
password!accessing!public! !
password:!accessing!public! !
port!accessing!public! !
port:!accessing!public! !
user!accessing!public! !
user:!accessing!public! !
!

