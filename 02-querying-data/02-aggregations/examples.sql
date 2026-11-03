/* Агрегирование данных. */
USE AdventureWorks2014;
GO
/* 1. Простой: разные формы COUNT отвечают на разные вопросы. */
SELECT COUNT(*) AS AllProducts,
       COUNT(Color) AS KnownColors,
       COUNT(DISTINCT Color) AS DistinctKnownColors,
       MIN(ListPrice) AS MinPrice,
       MAX(ListPrice) AS MaxPrice
FROM Production.Product;
GO

/* 2. Продвинутый: условные агрегаты и HAVING по итогам группы. */
SELECT CustomerID,
       COUNT(*) AS OrderCount,
       SUM(CASE WHEN TotalDue >= 1000 THEN 1 ELSE 0 END) AS LargeOrders,
       AVG(TotalDue) AS AverageOrder,
       SUM(TotalDue) AS TotalAmount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(*) >= 10 AND SUM(TotalDue) > 10000
ORDER BY TotalAmount DESC;
GO

/* 3. Практический: месячный отчёт продаж по территориям. */
SELECT t.Name AS Territory,
       DATEADD(month, DATEDIFF(month, 0, h.OrderDate), 0) AS MonthStart,
       COUNT(DISTINCT h.SalesOrderID) AS Orders,
       COUNT(DISTINCT h.CustomerID) AS Customers,
       SUM(d.LineTotal) AS Revenue
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
JOIN Sales.SalesTerritory AS t ON t.TerritoryID = h.TerritoryID
WHERE h.OrderDate >= '20130101' AND h.OrderDate < '20140101'
GROUP BY t.Name, DATEADD(month, DATEDIFF(month, 0, h.OrderDate), 0)
ORDER BY MonthStart, t.Name;
GO
