/* tempdb и переполнения временных операций. */
/* 1. Простой: текущее использование tempdb по файлам. */
SELECT DB_NAME(database_id) AS DatabaseName,
       SUM(user_object_reserved_page_count) * 8.0 / 1024 AS UserObjectsMB,
       SUM(internal_object_reserved_page_count) * 8.0 / 1024 AS InternalObjectsMB,
       SUM(version_store_reserved_page_count) * 8.0 / 1024 AS VersionStoreMB
FROM sys.dm_db_file_space_usage
GROUP BY database_id;
GO

/* 2. Продвинутый: активные задачи, резервирующие место в tempdb. */
SELECT s.session_id, s.request_id,
       (s.user_objects_alloc_page_count - s.user_objects_dealloc_page_count) * 8.0 / 1024 AS UserMB,
       (s.internal_objects_alloc_page_count - s.internal_objects_dealloc_page_count) * 8.0 / 1024 AS InternalMB
FROM sys.dm_db_task_space_usage AS s
WHERE s.session_id > 50
ORDER BY UserMB DESC, InternalMB DESC;
GO

/* 3. Практический: фактический план нужен для обнаружения Sort/Hash spill. */
USE AdventureWorks2014;
GO
SET STATISTICS XML ON;
SELECT h.CustomerID, d.ProductID, SUM(d.LineTotal) AS Amount
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
GROUP BY h.CustomerID, d.ProductID
ORDER BY h.CustomerID, d.ProductID;
SET STATISTICS XML OFF;
GO
/* В XML проверьте предупреждения SpillToTempDb, если они возникли при выполнении. */
