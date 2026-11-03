/* Секционирование и columnstore в хранилище данных 2014. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: агрегация по годам подходит для columnstore. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

/* 2. Продвинутый: обновляемый clustered columnstore на учебной таблице. */
CREATE TABLE #FactSalesCS
(
    DateKey int NOT NULL,
    ProductKey int NOT NULL,
    SalesAmount money NOT NULL
);
CREATE CLUSTERED COLUMNSTORE INDEX CCI_FactSalesCS ON #FactSalesCS;
INSERT #FactSalesCS
SELECT TOP (10000) OrderDateKey, ProductKey, SalesAmount
FROM dbo.FactInternetSales;
SELECT DateKey, SUM(SalesAmount) AS SalesAmount
FROM #FactSalesCS
GROUP BY DateKey
ORDER BY DateKey;
DROP TABLE #FactSalesCS;
GO

/* 3. Практический: секция месяца упрощает архивирование большого факта. */
SELECT d.CalendarYear, d.MonthNumberOfYear,
       COUNT_BIG(*) AS [RowCount], SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear
ORDER BY d.CalendarYear, d.MonthNumberOfYear;
GO
/* Для SWITCH секций нужны заранее выровненные постоянные таблицы и одинаковые ограничения. */
