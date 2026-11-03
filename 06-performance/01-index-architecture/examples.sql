/* Архитектура индексов. */
USE AdventureWorks2014;
GO
/* 1. Простой: индексы таблицы и их тип. */
SELECT i.name AS IndexName, i.type_desc, i.is_unique, i.is_primary_key
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID(N'Sales.SalesOrderDetail')
ORDER BY i.index_id;
GO

/* 2. Продвинутый: ключевые и включённые столбцы одного индекса. */
SELECT i.name AS IndexName, c.name AS ColumnName,
       ic.key_ordinal, ic.is_included_column, ic.is_descending_key
FROM sys.indexes AS i
JOIN sys.index_columns AS ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns AS c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
WHERE i.object_id = OBJECT_ID(N'Sales.SalesOrderHeader') AND i.index_id > 0
ORDER BY i.name, ic.is_included_column, ic.key_ordinal;
GO

/* 3. Практический: физическая фрагментация индекса после эксплуатации. */
SELECT OBJECT_NAME(ips.object_id) AS TableName,
       i.name AS IndexName, ips.index_type_desc,
       ips.avg_fragmentation_in_percent, ips.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), OBJECT_ID(N'Sales.SalesOrderDetail'), NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
ORDER BY ips.page_count DESC;
GO
