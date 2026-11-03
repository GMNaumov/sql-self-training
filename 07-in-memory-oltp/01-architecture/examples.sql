/* Архитектура In-Memory OLTP SQL Server 2014. */
/* 1. Простой: проверить редакцию и версию перед лабораторией. */
SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('Edition') AS Edition;
GO

/* 2. Продвинутый: найти memory-optimized файловые группы и таблицы. */
SELECT DB_NAME() AS DatabaseName, fg.name AS FilegroupName, fg.type_desc
FROM sys.filegroups AS fg
WHERE fg.type = N'FX';
SELECT s.name AS SchemaName, t.name AS TableName, t.durability_desc
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
WHERE t.is_memory_optimized = 1;
GO

/* 3. Практический: оценить кандидата по конфликтам и потреблению памяти. */
SELECT OBJECT_NAME(object_id) AS TableName,
       memory_used_by_table_kb, memory_used_by_indexes_kb
FROM sys.dm_db_xtp_table_memory_stats
ORDER BY memory_used_by_table_kb DESC;
GO
/* Для production дополнительно измерьте задержку, конфликты и ёмкость checkpoint-файлов. */
