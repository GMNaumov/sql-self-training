/* Источники и преобразования SSIS Data Flow. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: OLE DB Source возвращает только нужные столбцы. */
SELECT SalesOrderNumber, SalesOrderLineNumber,
       OrderDateKey, ProductKey, CustomerKey,
       OrderQuantity, SalesAmount
FROM dbo.FactInternetSales
WHERE OrderDateKey >= 20130101 AND OrderDateKey < 20140101;
GO

/* 2. Продвинутый: Lookup ищет продукт, а условный Split отделяет ошибки. */
SELECT s.SalesOrderNumber, s.ProductKey,
       p.ProductAlternateKey, p.EnglishProductName
FROM dbo.FactInternetSales AS s
LEFT JOIN dbo.DimProduct AS p ON p.ProductKey = s.ProductKey;
GO
/* В пакете строки p.ProductKey IS NULL направляются в error output, а не в факт. */

/* 3. Практический: агрегат в источнике уменьшает передачу строк в пакет. */
SELECT OrderDateKey, ProductKey,
       SUM(OrderQuantity) AS Quantity, SUM(SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales
WHERE OrderDateKey >= 20130101 AND OrderDateKey < 20140101
GROUP BY OrderDateKey, ProductKey;
GO
