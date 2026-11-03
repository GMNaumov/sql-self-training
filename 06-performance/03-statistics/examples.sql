/* Статистика распределения данных. */
USE AdventureWorks2014;
GO
/* 1. Простой: список объектов статистики таблицы. */
SELECT s.name AS StatisticsName, s.auto_created, s.user_created,
       sp.last_updated, sp.rows, sp.rows_sampled
FROM sys.stats AS s
CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
WHERE s.object_id = OBJECT_ID(N'Sales.SalesOrderHeader');
GO

/* 2. Продвинутый: гистограмма показывает границы и оценки диапазонов. */
DBCC SHOW_STATISTICS (N'Sales.SalesOrderHeader', N'IX_SalesOrderHeader_CustomerID')
WITH HISTOGRAM;
GO

/* 3. Практический: сравнение кардинальности перед обновлением статистики. */
SELECT p.CustomerID, COUNT(*) AS ActualRows
FROM Sales.SalesOrderHeader AS p
WHERE p.CustomerID IN (11000, 11001, 11002)
GROUP BY p.CustomerID;
/* На учебной копии после массовой загрузки:
UPDATE STATISTICS Sales.SalesOrderHeader IX_SalesOrderHeader_CustomerID WITH FULLSCAN;
*/
GO
