------------------------------------------------------------
--This script will encrypt all databases on the Instance 
--with a cert and turn on encryption
--Be Sure to change the Certificate name below
--03/31/2026 Update - Server Cert for TDE NVCC
------------------------------------------------------------
--Tim Collins
--12\23\2016
------------------------------------------------------------
declare @count1 int
declare @backupPath varchar(100)
declare @query1 varchar(max)
declare @query2 varchar(max)
declare @dbname varchar(max)

set @backupPath = 'C:\Bak\'

--Drop Temp Table if exists
IF OBJECT_ID('tempdb..#Database_Names1') IS NOT NULL
    DROP TABLE #Database_Names1

-- Select user databases
SELECT [name]
into #Database_Names1
FROM sys.databases 
WHERE state_desc = 'ONLINE'
and [name] not in(
'master',
'model',
'tempdb',
'msdb'
)
--
--


SELECT TABLE_NAME, COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE COLUMN_NAME = 'state_desc';

----

set @count1 = 1
while @count1 >= 1

begin
set @dbname =(select top 1 [name] from #Database_Names1)

--Be Sure to change the Certificate name below
set @query1=(
--User Database Encryption Key Creation
'USE [' + @dbName + '];
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
--Change Cert Name Here
ENCRYPTION BY SERVER CERTIFICATE TDE_MyServerCert_NVCC;'
)
--Encrypt Database
set @query2=(
'ALTER DATABASE [' + @dbName +
'] SET ENCRYPTION ON;'
)
--Print (@query1)
Exec(@query1)
--Print (@query2)
Exec(@query2)

delete from #Database_Names1 where name=@dbname

set @count1 =(select count(*) from #Database_Names1)
Print 'Done'
End
-----------------
--End Script
------------------
