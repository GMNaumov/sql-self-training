/* Источники данных и наборы данных SSRS. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: dataset годовых продаж. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

/* 2. Продвинутый: dataset с параметрами отчёта. */
-- Для автономного запуска задаём значения; в SSRS они сопоставляются параметрам отчёта.
DECLARE @CalendarYear smallint = 2013, @CategoryName nvarchar(50) = NULL;
SELECT d.CalendarYear, d.MonthNumberOfYear,
       pc.EnglishProductCategoryName, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey
WHERE d.CalendarYear = @CalendarYear
  AND (@CategoryName IS NULL OR pc.EnglishProductCategoryName = @CategoryName)
GROUP BY d.CalendarYear, d.MonthNumberOfYear, pc.EnglishProductCategoryName
ORDER BY d.MonthNumberOfYear, pc.EnglishProductCategoryName;
GO

/* 3. Практический: dataset для списка доступных лет. */
SELECT DISTINCT d.CalendarYear
FROM dbo.DimDate AS d
WHERE EXISTS (SELECT 1 FROM dbo.FactInternetSales AS f WHERE f.OrderDateKey = d.DateKey)
ORDER BY d.CalendarYear;
GO
