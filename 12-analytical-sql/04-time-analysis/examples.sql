/* Временной анализ через измерение даты. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: продажи по месяцам. */
SELECT d.CalendarYear, d.MonthNumberOfYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear
ORDER BY d.CalendarYear, d.MonthNumberOfYear;
GO

/* 2. Продвинутый: год к году через самосоединение месячных агрегатов. */
WITH Monthly AS
(
    SELECT d.CalendarYear, d.MonthNumberOfYear, SUM(f.SalesAmount) AS SalesAmount
    FROM dbo.FactInternetSales AS f
    JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
    GROUP BY d.CalendarYear, d.MonthNumberOfYear
)
SELECT cur.CalendarYear, cur.MonthNumberOfYear,
       cur.SalesAmount, prev.SalesAmount AS PreviousYearAmount,
       cur.SalesAmount - prev.SalesAmount AS YearOverYearDelta
FROM Monthly AS cur
LEFT JOIN Monthly AS prev
  ON prev.CalendarYear = cur.CalendarYear - 1
 AND prev.MonthNumberOfYear = cur.MonthNumberOfYear
ORDER BY cur.CalendarYear, cur.MonthNumberOfYear;
GO

/* 3. Практический: YTD с накоплением внутри календарного года. */
WITH Monthly AS
(
    SELECT d.CalendarYear, d.MonthNumberOfYear, SUM(f.SalesAmount) AS SalesAmount
    FROM dbo.FactInternetSales AS f
    JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
    GROUP BY d.CalendarYear, d.MonthNumberOfYear
)
SELECT CalendarYear, MonthNumberOfYear, SalesAmount,
       SUM(SalesAmount) OVER
       (PARTITION BY CalendarYear ORDER BY MonthNumberOfYear ROWS UNBOUNDED PRECEDING) AS YtdSales
FROM Monthly
ORDER BY CalendarYear, MonthNumberOfYear;
GO
