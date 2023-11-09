-- Chat-GPT
-- Select everything
DECLARE @dbName NVARCHAR(255) = 'Labb1'
DECLARE @tableName NVARCHAR(255)
DECLARE tableCursor CURSOR FOR 
    SELECT TABLE_NAME 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG = @dbName

OPEN tableCursor
FETCH NEXT FROM tableCursor INTO @tableName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = 'SELECT * FROM ' + @dbName + '.dbo.' + @tableName -- Assuming tables are in the "dbo" schema
    EXEC sp_executesql @sql
    
    FETCH NEXT FROM tableCursor INTO @tableName
END

CLOSE tableCursor
DEALLOCATE tableCursor

-- BACKUP DATABASE Labb1 TO DISK='F:\Coding\ITHSLabbar\SQLLabb1\Labb1.bak'