/* Типовые аналитические запросы. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: доля строки в общей сумме. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount,
       SUM(f.SalesAmount) * 100.0 /
       SUM(SUM(f.SalesAmount)) OVER () AS PercentOfTotal
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

/* 2. Продвинутый: Top-N товаров внутри каждого года. */
WITH ProductSales AS
(
    SELECT d.CalendarYear, f.ProductKey, SUM(f.SalesAmount) AS SalesAmount
    FROM dbo.FactInternetSales AS f
    JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
    GROUP BY d.CalendarYear, f.ProductKey
), Ranked AS
(
    SELECT CalendarYear, ProductKey, SalesAmount,
           ROW_NUMBER() OVER (PARTITION BY CalendarYear ORDER BY SalesAmount DESC, ProductKey) AS rn
    FROM ProductSales
)
SELECT * FROM Ranked WHERE rn <= 5 ORDER BY CalendarYear, rn;
GO

/* 3. Практический: скользящая сумма продаж за три месяца. */
WITH Monthly AS
(
    SELECT d.CalendarYear, d.MonthNumberOfYear, SUM(f.SalesAmount) AS SalesAmount
    FROM dbo.FactInternetSales AS f
    JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
    GROUP BY d.CalendarYear, d.MonthNumberOfYear
)
SELECT CalendarYear, MonthNumberOfYear, SalesAmount,
       AVG(SalesAmount) OVER
       (ORDER BY CalendarYear, MonthNumberOfYear ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM Monthly
ORDER BY CalendarYear, MonthNumberOfYear;
GO
