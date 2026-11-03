/* Источники табличной модели SSAS 2014 (compatibility 1103). */
USE AdventureWorksDW2014;
GO
/* 1. Простой: таблица фактов для импорта. */
SELECT SalesOrderNumber, SalesOrderLineNumber, OrderDateKey,
       ProductKey, CustomerKey, OrderQuantity, SalesAmount
FROM dbo.FactInternetSales;
GO

/* 2. Продвинутый: уникальность ключей обеих сторон связи. */
SELECT ProductKey, COUNT(*) AS KeyCount
FROM dbo.DimProduct
GROUP BY ProductKey
HAVING COUNT(*) > 1;
SELECT OrderDateKey, COUNT(*) AS FactRows
FROM dbo.FactInternetSales
GROUP BY OrderDateKey
ORDER BY OrderDateKey;
GO

/* 3. Практический: отфильтрованный импорт сокращает модель до нужного периода. */
SELECT f.SalesOrderNumber, f.SalesOrderLineNumber,
       f.OrderDateKey, f.ProductKey, f.CustomerKey, f.SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
WHERE d.CalendarYear >= 2012;
GO
/* DAX-запросы к развёрнутой модели находятся в examples.dax. */
