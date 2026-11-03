/* SQL-эталон для сравнения результатов MDX и DAX. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: годовая сумма интернет-продаж. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

/* 2. Продвинутый: сумма по году и категории. */
SELECT d.CalendarYear, pc.EnglishProductCategoryName, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey
GROUP BY d.CalendarYear, pc.EnglishProductCategoryName
ORDER BY d.CalendarYear, pc.EnglishProductCategoryName;
GO

/* 3. Практический: эталон для проверки модели после processing. */
SELECT COUNT(*) AS FactRows, SUM(f.SalesAmount) AS SalesAmount,
       MIN(d.FullDateAlternateKey) AS FirstSaleDate,
       MAX(d.FullDateAlternateKey) AS LastSaleDate
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey;
GO
/* Выполняйте examples.mdx и examples.dax в соответствующем SSAS, не в Database Engine. */
