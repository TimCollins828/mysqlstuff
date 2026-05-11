DECLARE @DB_Name NVARCHAR(128);
DECLARE @Command NVARCHAR(MAX);

-- Cursor to iterate through all non-system, online databases
DECLARE db_cursor CURSOR FOR 
SELECT name 
FROM sys.databases 
WHERE database_id > 4 -- Skip system databases (master, tempdb, model, msdb)
AND state_desc = 'ONLINE';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DB_Name;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Build dynamic SQL to find and drop orphaned users in the current database
    SET @Command = '
    USE [' + @DB_Name + '];
    DECLARE @OrphanName NVARCHAR(128);
    
    DECLARE orphan_cursor CURSOR FOR
    SELECT dp.name
    FROM sys.database_principals dp
    LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid
    WHERE sp.sid IS NULL
    AND dp.type IN (''S'', ''U'', ''G'') -- SQL User, Windows User, Windows Group
    AND dp.name NOT IN (''guest'', ''INFORMATION_SCHEMA'', ''sys'', ''dbo'', ''msdb'', ''broker_user'');

    OPEN orphan_cursor;
    FETCH NEXT FROM orphan_cursor INTO @OrphanName;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT ''Dropping orphaned user ['' + @OrphanName + ''] from database ['' + DB_NAME() + '']'';
        
        BEGIN TRY
            EXEC(''DROP USER ['' + @OrphanName + '']'');
        END TRY
        BEGIN CATCH
            PRINT ''FAILED to drop ['' + @OrphanName + '']. Reason: '' + ERROR_MESSAGE();
            -- Common reason: User owns a schema or role.
        END CATCH

        FETCH NEXT FROM orphan_cursor INTO @OrphanName;
    END

    CLOSE orphan_cursor;
    DEALLOCATE orphan_cursor;';

    EXEC sp_executesql @Command;

    FETCH NEXT FROM db_cursor INTO @DB_Name;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
