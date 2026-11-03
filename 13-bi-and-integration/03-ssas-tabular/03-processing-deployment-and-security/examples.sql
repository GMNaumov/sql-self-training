/* Контроль данных до processing Tabular и проверки безопасности. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: контрольная сумма факта до обновления модели. */
SELECT COUNT(*) AS FactRows, SUM(SalesAmount) AS SalesAmount,
       MAX(OrderDateKey) AS MaxOrderDateKey
FROM dbo.FactInternetSales;
GO

/* 2. Продвинутый: потерянные ключи вызывают неверные или пустые результаты модели. */
SELECT TOP (50) SalesOrderNumber, SalesOrderLineNumber
FROM dbo.FactInternetSales AS f
LEFT JOIN dbo.DimCustomer AS c ON c.CustomerKey = f.CustomerKey
WHERE c.CustomerKey IS NULL;
GO

/* 3. Практический: эталон для роли, ограниченной страной United States. */
SELECT SUM(f.SalesAmount) AS UnitedStatesSales
FROM dbo.FactInternetSales AS f
JOIN dbo.DimCustomer AS c ON c.CustomerKey = f.CustomerKey
JOIN dbo.DimGeography AS g ON g.GeographyKey = c.GeographyKey
WHERE g.EnglishCountryRegionName = N'United States';
GO
/* После processing DAX-запрос под тестовой ролью должен дать согласованный результат. */
