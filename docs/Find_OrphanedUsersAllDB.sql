EXEC sp_MSforeachdb '
USE [?]
SELECT 
    DB_NAME() AS DatabaseName,
    name AS OrphanedUser,
    type_desc
FROM sys.database_principals 
WHERE sid NOT IN (SELECT sid FROM master.sys.server_principals) 
    AND type_desc IN (''SQL_USER'', ''WINDOWS_USER'')
    AND name NOT IN (''guest'', ''INFORMATION_SCHEMA'', ''sys'', ''dbo'')'
