"Filed out from Dolphin Smalltalk"!

TestResource subclass: #MySQLTestResource
	instanceVariableNames: 'conn testConn'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySQLTestResource guid: (GUID fromString: '{211e79f1-2728-46b3-89eb-5df7af44ab44}')!

MySQLTestResource comment: 'Test resource for MySQL testing.Requires MySQL running on the localhost (or edit the ip in driverSpecNoDb) and the following user to be setup:create user ''sodbxtest''@''<test ip or *>'' identified by ''sodbxtest'';grant create, drop, create user, select, insert, update, delete  on *.*  to ''sodbxtest''@''<test ip or *>'';'!

!MySQLTestResource categoriesForClass!MySQL-Core-Tests-Integration-Test-Resources! !

!MySQLTestResource methodsFor!

clearTestTables	#(	'nameValue' 'warn' 'mix' 'testMisc' 'testIntegers' 'testReals' 'testTimes' 'testChars'	'testBinaries' 'testBlobs' 'testTexts') 		do: [:each | conn query: 'truncate table ', each]!

connectToServer	| resp |	conn := MySQLDriver new.	resp := conn connect: self class driverSpecNoDb.	resp isOkay 		ifFalse: [ ^ self error: ('Failed to connect to MySQL server [<1s>]' expandMacrosWith: resp message)]!

createAlternativeUser	"Creates an alternative user with the same password as the main test user"	| resp |	resp := conn query: 'CREATE USER ''', self class alternativeUsername , '''@''%''IDENTIFIED BY ''', self class driverSpecNoDb password , ''';'.	resp isOkay ifFalse: [^ self error: 'Can not create second user'].!

createMiscTestTables	| resp |	self ddlMiscTestTables do: [:each |		resp := conn query: each.		resp isError ifTrue: [^ self error: 'Error creating misc test table: ', resp message]]	!

createTestDb	| resp |	resp := conn query: 'create database if not exists ', self class dbName, ' DEFAULT CHARACTER SET latin1'.	resp isOkay ifFalse: [^ self error: 'Can not create test database'].		resp := conn query: 'use ', self class dbName.	resp isError ifTrue: [^ self error: 'Failed to use test database'].	!

createTypeTestTables	| resp |	self ddlTypeTestTables do: [:each |		resp := conn query: each.		resp isError ifTrue: [^ self error: 'Error creating type test table: ', resp message]]	!

ddlMiscTestTables	^ #(	'create table if not exists nameValue (		id int not null auto_increment primary key,		name varchar(256) not null unique key,		value varchar(1024) not null default ''aeiou''	) engine = InnoDB'		'/* for testing warnings */	create table if not exists warn (		c1 tinyint not null,		c2 varchar(32)	)'	'create table if not exists mix (		name varchar(256) not null primary key,		value decimal(21,9) default null	) engine = InnoDB'			'create table if not exists testMisc (		name varchar(100) not null primary key,		value varchar(1000) not null,		entryOn date not null,		notes varchar(1000)	) engine = InnoDB'		'create table if not exists testWideTable (		id int auto_increment not null primary key,		name varchar(100),		shortDescription varchar(200),		longDescription varchar(1000),		categotyCode int,		categoryName varchar(200),		supplierCode int,		supplierName varchar(200),		colorCode int,		colorName varchar(100),		colorSource int,		colorSourceName varchar(100),		size int,		attributeA varchar(100),		attributeB varchar(100),		attributeC varchar(100),		attributeD varchar(100),		attributeE varchar(100),		attributeF varchar(100),		attributeG varchar(100),		attributeH varchar(100),		attributeI varchar(100),		attributeJ varchar(100),		attributeK varchar(100),		attributeL varchar(100),		attributeM varchar(100),		attributeN varchar(100),		attributeO varchar(100),		attributeP varchar(100),		attributeQ varchar(100),		attributeR varchar(100),		attributeS varchar(100),		attributeT varchar(100),		attributeU varchar(100),		attributeV varchar(100),		attributeW varchar(100),		attributeX varchar(100),		attributeY varchar(100),		attributeZ varchar(100)	) engine = InnoDB'	)!

ddlTypeTestTables	^ #(		'create table if not exists testIntegers (		id int auto_increment primary key,		tinyintValue tinyint,		smallintValue smallint,		mediumintValue mediumint,		intValue int,		bigintValue bigint	) engine = InnoDB'		'create table if not exists testReals (		id int auto_increment primary key,		floatValue float,		doubleValue double,		realValue real,		decimalValue decimal(10,6),		numericValue numeric(10, 6)	) engine = InnoDB'		'create table if not exists testTimes (		id int auto_increment primary key,		dateValue date,		timeValue time,		datetimeValue datetime,		timestampValue timestamp,		yearValue year	) engine = InnoDB'		'create table if not exists testChars (		id int auto_increment primary key,		charValue char(100),		varcharValue varchar(1000)	) engine = InnoDB'		'create table if not exists testBinaries (		id int auto_increment primary key,		binaryValue binary,		varbinaryValue varbinary(256)	) engine = InnoDB'		'create table if not exists testBlobs (		id int auto_increment primary key,		tinyblobValue tinyblob,		blobValue blob,		mediumblobValue mediumblob,		longblobValue longBlob	) engine = InnoDB'		'create table if not exists testTexts (		id int auto_increment primary key,		tinytextValue tinytext,		textValue text,		mediumtextValue mediumtext,		longtextValue longtext	) engine = InnoDB'		)!

deleteAlternativeUser	| resp |	resp := conn query: 'DROP USER ''', self class alternativeUsername, ''';'.	resp isOkay ifFalse: [^ self error: 'Can not create second user'].!

deleteTestDb	| resp |	resp := conn query: 'drop database if exists ', self class dbName.	resp isOkay ifFalse: [^ self error: 'Can not create test database']	!

disconnecTestConnection	testConn ifNotNil:[		[testConn disconnect] on: MySQLNoConnectionError do: [:ex |]]!

disconnectFromServer	[conn disconnect] on: MySQLNoConnectionError do: [:ex |].!

resourceConnection	^ conn	!

setUp	self 		connectToServer;		createTestDb;		createAlternativeUser;		createMiscTestTables;		createTypeTestTables.		!

tearDown	self disconnecTestConnection.		self deleteTestDb.	self deleteAlternativeUser.	self disconnectFromServer.!

testConnection	"Returns a connection to be used for the testXyz methods. 	Not to be confused with the internal connection instance 	for setting up schemas and tables"	(testConn isNil or: [ testConn connected not ]) 		ifTrue: [			testConn := MySQLDriver new.			testConn connect: self class driverSpecWithDb].	^ testConn! !

!MySQLTestResource categoriesForMethods!
clearTestTables!cleanup!public! !
connectToServer!public!utilities! !
createAlternativeUser!public!utilities! !
createMiscTestTables!public!utilities! !
createTestDb!public!utilities! !
createTypeTestTables!public!utilities! !
ddlMiscTestTables!public!utilities! !
ddlTypeTestTables!public!utilities! !
deleteAlternativeUser!public!utilities! !
deleteTestDb!public!utilities! !
disconnecTestConnection!public!utilities! !
disconnectFromServer!public!utilities! !
resourceConnection!public!utilities! !
setUp!public!running! !
tearDown!public!running! !
testConnection!public!utilities! !
!

!MySQLTestResource class methodsFor!

alternativeUsername	^ 'sodbxtest2'!

dbName	^ 'sodbxtest2'!

driverSpecNoDb	^ MySQLDriverSpec new		host: '192.168.1.104';		port: 3306;		user: 'sodbxtest';		password: 'sodbxtest';		yourself!

driverSpecWithDb	^ self driverSpecNoDb		db: self dbName;		yourself		! !

!MySQLTestResource class categoriesForMethods!
alternativeUsername!accessing!public! !
dbName!accessing!public! !
driverSpecNoDb!accessing!public! !
driverSpecWithDb!accessing!public! !
!

