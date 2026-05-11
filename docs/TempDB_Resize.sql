USE tempdb;
GO

-- ==========================================
-- Step 1: Review current TempDB file sizes
-- ==========================================
SELECT 
    name AS FileName,
    type_desc AS FileType,
    size * 8 / 1024 AS SizeMB,
    physical_name
FROM sys.master_files
WHERE database_id = DB_ID('tempdb');
GO

-- ==========================================
-- Step 2: Set target size (in MB)
-- Change @TargetSizeMB to your desired size
-- ==========================================
DECLARE @TargetSizeMB INT = 16000; -- Example: 1 GB per file
DECLARE @SQL NVARCHAR(MAX) = N'';

-- ==========================================
-- Step 3: Generate ALTER DATABASE commands
-- ==========================================
SELECT @SQL = STRING_AGG(
    'ALTER DATABASE tempdb MODIFY FILE (NAME = ' + QUOTENAME(name) +
    ', SIZE = ' + CAST(@TargetSizeMB AS NVARCHAR(10)) + 'MB);', 
    CHAR(13) + CHAR(10)
)
FROM sys.master_files
WHERE database_id = DB_ID('tempdb')
  AND type_desc = 'ROWS'; -- Only data files, not log

PRINT '-- Generated Resize Commands --';
PRINT @SQL;
GO

-- ==========================================
-- Step 4: Execute the resize
-- ==========================================
-- ⚠️ Make sure target size is >= current used space
-- Otherwise, shrink first if needed
EXEC sp_executesql @SQL;
GO

-- ==========================================
-- Step 5: (Optional) Shrink files if they are larger than needed
-- ==========================================
-- Use with caution; shrinking can cause fragmentation
-- Example for one file:
-- DBCC SHRINKFILE (tempdev, 1024); -- Shrink to 1 GB

-- Generated Resize Commands --
--ALTER DATABASE tempdb MODIFY FILE (NAME = [tempdev], SIZE = 16000MB);
--ALTER DATABASE tempdb MODIFY FILE (NAME = [temp2], SIZE = 16000MB);
--ALTER DATABASE tempdb MODIFY FILE (NAME = [temp3], SIZE = 16000MB);
--ALTER DATABASE tempdb MODIFY FILE (NAME = [temp4], SIZE = 16000MB);
--ALTER DATABASE tempdb MODIFY FILE (NAME = [temp5], SIZE = 16000MB);
--ALTER DATABASE tempdb MODIFY FILE (NAME = [temp6], SIZE = 16000MB);