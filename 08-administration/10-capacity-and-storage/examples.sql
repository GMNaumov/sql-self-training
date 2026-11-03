/* Ёмкость и хранилище. */
/* 1. Простой: размеры файлов всех баз. */
SELECT d.name AS DatabaseName, mf.type_desc,
       SUM(mf.size) * 8.0 / 1024 AS SizeMB
FROM sys.databases AS d
JOIN sys.master_files AS mf ON mf.database_id = d.database_id
GROUP BY d.name, mf.type_desc
ORDER BY d.name, mf.type_desc;
GO

/* 2. Продвинутый: крупнейшие таблицы текущей базы. */
USE AdventureWorks2014;
GO
SELECT TOP (20) s.name AS SchemaName, t.name AS TableName,
       SUM(p.rows) AS [RowCount], SUM(a.total_pages) * 8.0 / 1024 AS SizeMB
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id IN (0, 1)
JOIN sys.allocation_units AS a ON a.container_id = p.hobt_id
GROUP BY s.name, t.name
ORDER BY SizeMB DESC;
GO

/* 3. Практический: рост базы по размерам исторических backup — только приближение. */
SELECT database_name, backup_finish_date,
       backup_size / 1048576.0 AS CompressedBackupMB,
       compressed_backup_size / 1048576.0 AS StoredBackupMB
FROM msdb.dbo.backupset
WHERE database_name = N'AdventureWorks2014' AND type = 'D'
ORDER BY backup_finish_date;
GO
