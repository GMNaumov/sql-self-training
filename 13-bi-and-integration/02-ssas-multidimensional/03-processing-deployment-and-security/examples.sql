/* SQL-проверки перед processing и настройкой ролей SSAS. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: контрольные суммы до processing. */
SELECT COUNT(*) AS FactRows, SUM(SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales;
GO

/* 2. Продвинутый: суммы по годам для сверки с кубом. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

/* 3. Практический: данные роли «только США» для проверки allowed set. */
SELECT g.EnglishCountryRegionName, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimCustomer AS c ON c.CustomerKey = f.CustomerKey
JOIN dbo.DimGeography AS g ON g.GeographyKey = c.GeographyKey
WHERE g.EnglishCountryRegionName = N'United States'
GROUP BY g.EnglishCountryRegionName;
GO
/* Processing выполняется в SSAS (XMLA), а не этим T-SQL; роли проверяются тестовым пользователем. */
