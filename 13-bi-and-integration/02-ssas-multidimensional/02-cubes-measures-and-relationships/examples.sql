/* SQL-основа куба, мер и связей SSAS Multidimensional. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: мера Sum по SalesAmount. */
SELECT SUM(SalesAmount) AS SalesAmount, SUM(OrderQuantity) AS OrderQuantity
FROM dbo.FactInternetSales;
GO

/* 2. Продвинутый: мера Distinct Count по заказам. */
SELECT COUNT(DISTINCT SalesOrderNumber) AS InternetOrderCount
FROM dbo.FactInternetSales;
GO

/* 3. Практический: контроль связи факта с Product и Date. */
SELECT TOP (50) f.SalesOrderNumber, f.SalesOrderLineNumber,
       CASE WHEN p.ProductKey IS NULL THEN N'Product' ELSE N'Date' END AS MissingDimension
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
LEFT JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
WHERE p.ProductKey IS NULL OR d.DateKey IS NULL;
GO
/* MDX-запросы к созданному кубу находятся в examples.mdx. */
