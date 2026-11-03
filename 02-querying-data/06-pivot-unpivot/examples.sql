/* PIVOT и UNPIVOT. */
USE AdventureWorks2014;
GO
/* 1. Простой: годовая выручка по категориям. */
WITH SourceData AS
(
    SELECT pc.Name AS Category, YEAR(h.OrderDate) AS SalesYear, d.LineTotal
    FROM Sales.SalesOrderHeader AS h
    JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
    JOIN Production.Product AS p ON p.ProductID = d.ProductID
    JOIN Production.ProductSubcategory AS ps
      ON ps.ProductSubcategoryID = p.ProductSubcategoryID
    JOIN Production.ProductCategory AS pc ON pc.ProductCategoryID = ps.ProductCategoryID
)
SELECT Category, [2011], [2012], [2013], [2014]
FROM SourceData
PIVOT (SUM(LineTotal) FOR SalesYear IN ([2011], [2012], [2013], [2014])) AS p
ORDER BY Category;
GO

/* 2. Продвинутый: динамический список лет формируется через QUOTENAME. */
DECLARE @Columns nvarchar(max) = N'',
        @Sql nvarchar(max);
SELECT @Columns += N',' + QUOTENAME(CAST(SalesYear AS nvarchar(4)))
FROM (SELECT DISTINCT YEAR(OrderDate) AS SalesYear FROM Sales.SalesOrderHeader) AS y
ORDER BY SalesYear;
SET @Columns = STUFF(@Columns, 1, 1, N'');
SET @Sql = N'
WITH S AS
(
    SELECT TerritoryID, YEAR(OrderDate) AS SalesYear, TotalDue
    FROM Sales.SalesOrderHeader
)
SELECT TerritoryID, ' + @Columns + N'
FROM S PIVOT (SUM(TotalDue) FOR SalesYear IN (' + @Columns + N')) AS p
ORDER BY TerritoryID;';
EXEC sys.sp_executesql @Sql;
GO

/* 3. Практический: вернуть показатели магазина из колонок в строки. */
CREATE TABLE #StoreKpi
(
    StoreID int NOT NULL,
    Revenue decimal(19,4) NOT NULL,
    Expenses decimal(19,4) NOT NULL,
    ReturnsAmount decimal(19,4) NOT NULL
);
INSERT #StoreKpi VALUES (1, 100000, 70000, 2000), (2, 85000, 61000, 1500);
SELECT StoreID, Metric, Amount
FROM #StoreKpi
UNPIVOT (Amount FOR Metric IN (Revenue, Expenses, ReturnsAmount)) AS u
ORDER BY StoreID, Metric;
DROP TABLE #StoreKpi;
GO
