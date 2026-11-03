/* Продвинутые задачи SQL: islands, Top-N и свёртка. */
USE AdventureWorks2014;
GO
/* 1. Простой: пивот продаж по годам. */
SELECT CustomerID,
       SUM(CASE WHEN YEAR(OrderDate) = 2012 THEN SubTotal ELSE 0 END) AS Sales2012,
       SUM(CASE WHEN YEAR(OrderDate) = 2013 THEN SubTotal ELSE 0 END) AS Sales2013,
       SUM(CASE WHEN YEAR(OrderDate) = 2014 THEN SubTotal ELSE 0 END) AS Sales2014
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY CustomerID;
GO

/* 2. Продвинутый: три самых дорогих товара в каждой подкатегории. */
WITH Ranked AS
(
    SELECT p.ProductSubcategoryID, p.ProductID, p.Name, p.ListPrice,
           ROW_NUMBER() OVER (PARTITION BY p.ProductSubcategoryID ORDER BY p.ListPrice DESC, p.ProductID) AS rn
    FROM Production.Product AS p
    WHERE p.ListPrice > 0
)
SELECT * FROM Ranked WHERE rn <= 3 ORDER BY ProductSubcategoryID, rn;
GO

/* 3. Практический: непрерывные месяцы активности клиента (gaps and islands). */
WITH Months AS
(
    SELECT DISTINCT CustomerID,
           DATEADD(month, DATEDIFF(month, 0, OrderDate), 0) AS MonthStart
    FROM Sales.SalesOrderHeader
), Groups AS
(
    SELECT CustomerID, MonthStart,
           DATEADD(month, -DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY MonthStart), MonthStart) AS GroupMarker
    FROM Months
)
SELECT CustomerID, MIN(MonthStart) AS IslandStart,
       MAX(MonthStart) AS IslandEnd, COUNT(*) AS ConsecutiveMonths
FROM Groups
GROUP BY CustomerID, GroupMarker
ORDER BY CustomerID, IslandStart;
GO
