/* Знакомство с AdventureWorksDW2014. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: состав схемы и размеры таблиц. */
SELECT TOP (20) s.name AS SchemaName, t.name AS TableName,
       SUM(p.rows) AS [RowCount]
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id IN (0, 1)
GROUP BY s.name, t.name
ORDER BY [RowCount] DESC;
GO

/* 2. Продвинутый: интернет- и реселлерские продажи не смешиваем без общей модели. */
SELECT N'Internet' AS Channel, d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
UNION ALL
SELECT N'Reseller', d.CalendarYear, SUM(f.SalesAmount)
FROM dbo.FactResellerSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY Channel, CalendarYear;
GO

/* 3. Практический: динамика интернет-продаж по месяцам. */
SELECT d.CalendarYear, d.MonthNumberOfYear,
       MIN(d.FullDateAlternateKey) AS MonthStart,
       SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear
ORDER BY d.CalendarYear, d.MonthNumberOfYear;
GO
