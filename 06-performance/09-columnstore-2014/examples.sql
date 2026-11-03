/* Columnstore SQL Server 2014: clustered обновляемый, nonclustered — read-only. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: аналитическая агрегация по годам. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

/* 2. Продвинутый: увидеть существующие columnstore-индексы базы. */
SELECT OBJECT_NAME(i.object_id) AS TableName, i.name AS IndexName, i.type_desc
FROM sys.indexes AS i
WHERE i.type IN (5, 6)
ORDER BY TableName;
GO

/* 3. Практический: создание кластерного columnstore на новой учебной таблице. */
CREATE TABLE #SalesColumnstore
(
    OrderDateKey int NOT NULL,
    ProductKey int NOT NULL,
    SalesAmount money NOT NULL
);
CREATE CLUSTERED COLUMNSTORE INDEX CCI_SalesColumnstore ON #SalesColumnstore;
INSERT #SalesColumnstore
SELECT TOP (10000) OrderDateKey, ProductKey, SalesAmount
FROM dbo.FactInternetSales;
SELECT OrderDateKey, SUM(SalesAmount) AS SalesAmount
FROM #SalesColumnstore
GROUP BY OrderDateKey
ORDER BY OrderDateKey;
DROP TABLE #SalesColumnstore;
GO
