/* Макет и параметры SSRS: данные для таблицы и графика. */
USE AdventureWorksDW2014;
-- Для автономного запуска; в SSRS эти значения приходят из параметров отчёта.
-- Переменные объявлены в одном пакете с запросами, без промежуточного GO.
DECLARE @CalendarYear smallint = 2013, @OrderNumber nvarchar(20) = N'SO43697';
/* 1. Простой: строки таблицы отчёта с сортировкой на сервере. */
SELECT d.CalendarYear, d.EnglishMonthName,
       SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
WHERE d.CalendarYear = @CalendarYear
GROUP BY d.CalendarYear, d.MonthNumberOfYear, d.EnglishMonthName
ORDER BY d.MonthNumberOfYear;
GO

/* 2. Продвинутый: мультизначение параметра передаётся табличной переменной. */
DECLARE @Categories table (CategoryName nvarchar(50) NOT NULL PRIMARY KEY);
INSERT @Categories VALUES (N'Bikes'), (N'Accessories');
SELECT pc.EnglishProductCategoryName, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey
WHERE EXISTS (SELECT 1 FROM @Categories AS c WHERE c.CategoryName = pc.EnglishProductCategoryName)
GROUP BY pc.EnglishProductCategoryName;
GO

/* 3. Практический: пустой результат параметра должен быть осмысленным. */
DECLARE @CalendarYear smallint = 2013, @OrderNumber nvarchar(20) = N'SO43697';
SELECT d.FullDateAlternateKey, f.SalesOrderNumber, f.SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
WHERE d.CalendarYear = @CalendarYear
  AND f.SalesOrderNumber = @OrderNumber
ORDER BY f.SalesOrderNumber;
GO
/* В отчёте настройте NoRowsMessage и проверьте допустимые значения параметров. */
