--Restore Database with Cert/Key
--------------------------------
--These scripts will help you determine what keys and certificates are on the database. Be sure to run this in the --
--Master as well as in the Source Database so you can see the Master Key as well. Note that an encryption state of 3 --is encrypted. 
--The password in the Create cert section is the actual password used for decrypting the attached cert/key.

use master
go
select * from sys.symmetric_keys
select * FROM sys.dm_database_encryption_keys

-- Create Master if one doesn’t exist
USE master
GO
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'StrongPasswordHere'
GO
-

--Create cert and key on Destination from Source (the one we saved earlier)
--NOTE:Change your path to where you have put the files.
Use master
go
CREATE CERTIFICATE NSDD38_DB_Cert
FROM FILE = 'd:\temp\TDE_TEST\NSDD38_DB_Cert.cer'     
WITH PRIVATE KEY (FILE = 'd:\temp\TDE_TEST\NSDD38_DB_Key.pvk', 
DECRYPTION BY PASSWORD = 'NewP@ssW0rd45$%')

-- Restore Database
--Restore the database with your preferred method.

--Review encryption status
Select encryption_state, *
FROM sys.dm_database_encryption_keys;
GO
select * from sys.databases
go
