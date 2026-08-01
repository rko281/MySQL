# MySQL for Dolphin
* Native (non-ODBC) MySQL interface for Dolphin Smalltalk.
* Based on the Pharo implementation from [pharo-rdbms](https://github.com/pharo-rdbms).
* Primarily for use with [ReStore](https://github.com/rko281/ReStore) relational database interface.

### Caching SHA-2 Pluggable Authentication
Now supports MySQL's [caching_sha2_password](https://dev.mysql.com/doc/refman/9.7/en/caching-sha2-pluggable-authentication.html) authentication using [OpenSSL](https://github.com/rko281/OpenSSL) for secure socket communication.

To use secure socket communication specify `useSecureConnection` when creating your driver spec (connection information): 

```smalltalk
MySQLDriverSpec new
    db: 'my_database';
    host: '192.168.1.234';
    user: 'my_user';
    password: 'my_password';
    useSecureConnection;
    yourself
```
