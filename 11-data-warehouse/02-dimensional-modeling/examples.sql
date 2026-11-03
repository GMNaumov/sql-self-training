/* Измерительное моделирование: факт и измерения. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: продажи по календарному году. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

/* 2. Продвинутый: два смысла даты требуют разных ролей измерения. */
SELECT d.CalendarYear AS OrderYear, SUM(f.SalesAmount) AS OrderedAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO
/* Для ShipDateKey добавьте вторую роль Date, а не дополнительный фильтр к OrderDate. */

/* 3. Практический: продажи по географии клиента. */
SELECT g.EnglishCountryRegionName, g.StateProvinceName,
       SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimCustomer AS c ON c.CustomerKey = f.CustomerKey
JOIN dbo.DimGeography AS g ON g.GeographyKey = c.GeographyKey
GROUP BY g.EnglishCountryRegionName, g.StateProvinceName
ORDER BY SalesAmount DESC;
GO
