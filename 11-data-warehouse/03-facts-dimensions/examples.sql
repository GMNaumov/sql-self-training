/* Таблицы фактов и измерений. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: зерно FactInternetSales — строка позиции заказа. */
SELECT SalesOrderNumber, SalesOrderLineNumber, ProductKey,
       OrderQuantity, SalesAmount
FROM dbo.FactInternetSales
WHERE SalesOrderNumber = N'SO43697'
ORDER BY SalesOrderLineNumber;
GO

/* 2. Продвинутый: аддитивная мера и количество уникальных заказов. */
SELECT f.ProductKey,
       SUM(f.SalesAmount) AS SalesAmount,
       COUNT(*) AS FactRowCount,
       COUNT(DISTINCT f.SalesOrderNumber) AS OrderCount
FROM dbo.FactInternetSales AS f
GROUP BY f.ProductKey
ORDER BY SalesAmount DESC;
GO

/* 3. Практический: контроль ссылочной целостности загруженного факта. */
SELECT TOP (50) f.SalesOrderNumber, f.SalesOrderLineNumber, f.ProductKey
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
WHERE p.ProductKey IS NULL;
GO
/* Пустой результат означает отсутствие неизвестных ProductKey в проверенном наборе. */
