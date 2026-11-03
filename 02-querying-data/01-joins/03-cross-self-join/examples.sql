/* CROSS JOIN и самосоединения. */
USE AdventureWorks2014;
GO
/* 1. Простой: декартово произведение двух малых справочников. */
WITH Colors AS
(
    SELECT DISTINCT Color FROM Production.Product WHERE Color IN (N'Red', N'Black')
),
Sizes AS
(
    SELECT DISTINCT Size FROM Production.Product WHERE Size IN (N'M', N'L')
)
SELECT Color, Size
FROM Colors CROSS JOIN Sizes
ORDER BY Color, Size;
GO

/* 2. Продвинутый: самосоединение сравнивает товары внутри категории. */
SELECT p1.ProductSubcategoryID, p1.ProductID AS CheaperProductID,
       p2.ProductID AS DearerProductID,
       p2.ListPrice - p1.ListPrice AS PriceDifference
FROM Production.Product AS p1
JOIN Production.Product AS p2
  ON p2.ProductSubcategoryID = p1.ProductSubcategoryID
 AND p2.ListPrice > p1.ListPrice
WHERE p1.ProductSubcategoryID IS NOT NULL
ORDER BY PriceDifference DESC, p1.ProductID, p2.ProductID;
GO

/* 3. Практический: полная сетка месяц — территория, включая нулевые продажи. */
WITH Months AS
(
    SELECT DATEADD(month, v.n, '20130101') AS MonthStart
    FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11)) AS v(n)
),
MonthlySales AS
(
    SELECT h.TerritoryID,
           DATEADD(month, DATEDIFF(month, 0, h.OrderDate), 0) AS MonthStart,
           SUM(h.TotalDue) AS Revenue
    FROM Sales.SalesOrderHeader AS h
    WHERE h.OrderDate >= '20130101' AND h.OrderDate < '20140101'
    GROUP BY h.TerritoryID, DATEADD(month, DATEDIFF(month, 0, h.OrderDate), 0)
)
SELECT t.Name AS Territory, m.MonthStart, ISNULL(s.Revenue, 0) AS Revenue
FROM Months AS m
CROSS JOIN Sales.SalesTerritory AS t
LEFT JOIN MonthlySales AS s
  ON s.TerritoryID = t.TerritoryID AND s.MonthStart = m.MonthStart
ORDER BY t.Name, m.MonthStart;
GO
