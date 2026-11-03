/* Ограничения и миграция в In-Memory OLTP 2014. */
USE AdventureWorks2014;
GO
/* 1. Простой: инвентаризация типов и ограничений исходной таблицы. */
SELECT c.name AS ColumnName, ty.name AS DataType, c.max_length, c.is_nullable
FROM sys.columns AS c
JOIN sys.types AS ty ON ty.user_type_id = c.user_type_id
WHERE c.object_id = OBJECT_ID(N'Sales.SalesOrderHeader')
ORDER BY c.column_id;
GO

/* 2. Продвинутый: вычислить объём исходных данных перед оценкой памяти. */
SELECT t.name AS TableName,
       SUM(p.row_count) AS [RowCount],
       SUM(a.total_pages) * 8.0 / 1024 AS TotalMB
FROM sys.tables AS t
JOIN sys.dm_db_partition_stats AS p ON p.object_id = t.object_id AND p.index_id IN (0, 1)
JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
WHERE t.name = N'SalesOrderHeader'
GROUP BY t.name;
GO

/* 3. Практический: сначала карта несовместимости, затем учебная миграция. */
SELECT fk.name AS ForeignKeyName,
       OBJECT_NAME(fk.parent_object_id) AS ChildTable,
       OBJECT_NAME(fk.referenced_object_id) AS ParentTable
FROM sys.foreign_keys AS fk
WHERE fk.parent_object_id = OBJECT_ID(N'Sales.SalesOrderHeader')
   OR fk.referenced_object_id = OBJECT_ID(N'Sales.SalesOrderHeader');
GO
/* В 2014 нельзя добавить memory-optimized индекс позже: проектируйте его в CREATE TABLE. */
