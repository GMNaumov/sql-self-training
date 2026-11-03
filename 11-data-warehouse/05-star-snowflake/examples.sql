/* Звезда и снежинка: пути соединений. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: звезда — факт напрямую соединён с продуктом. */
SELECT p.EnglishProductName, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
GROUP BY p.EnglishProductName
ORDER BY SalesAmount DESC;
GO

/* 2. Продвинутый: категория достигается через подкатегорию. */
SELECT pc.EnglishProductCategoryName,
       ps.EnglishProductSubcategoryName,
       SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey
GROUP BY pc.EnglishProductCategoryName, ps.EnglishProductSubcategoryName
ORDER BY SalesAmount DESC;
GO

/* 3. Практический: единый календарь связывает аналогичные отчёты. */
SELECT d.FiscalYear, d.FiscalQuarter, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.FiscalYear, d.FiscalQuarter
ORDER BY d.FiscalYear, d.FiscalQuarter;
GO
