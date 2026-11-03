/* GROUPING SETS, ROLLUP и CUBE. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: ROLLUP добавляет итоги по годам и общий итог. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY ROLLUP(d.CalendarYear)
ORDER BY d.CalendarYear;
GO

/* 2. Продвинутый: явные наборы группировки и GROUPING для NULL-итогов. */
SELECT d.CalendarYear, pc.EnglishProductCategoryName,
       GROUPING(d.CalendarYear) AS IsYearTotal,
       SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey
GROUP BY GROUPING SETS
(
    (d.CalendarYear, pc.EnglishProductCategoryName),
    (d.CalendarYear),
    ()
)
ORDER BY d.CalendarYear, pc.EnglishProductCategoryName;
GO

/* 3. Практический: CUBE строит все сочетания года и категории. */
SELECT d.CalendarYear, pc.EnglishProductCategoryName, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey
JOIN dbo.DimProductCategory AS pc ON pc.ProductCategoryKey = ps.ProductCategoryKey
GROUP BY CUBE(d.CalendarYear, pc.EnglishProductCategoryName)
ORDER BY d.CalendarYear, pc.EnglishProductCategoryName;
GO
