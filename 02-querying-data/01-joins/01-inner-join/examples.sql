/* INNER JOIN. */
USE AdventureWorks2014;
GO
/* 1. Простой: каждая позиция соединяется со своим товаром. */
SELECT TOP (20) d.SalesOrderID, p.Name, d.OrderQty, d.LineTotal
FROM Sales.SalesOrderDetail AS d
JOIN Production.Product AS p ON p.ProductID = d.ProductID
ORDER BY d.SalesOrderID, d.SalesOrderDetailID;
GO

/* 2. Продвинутый: сначала агрегируем позиции, чтобы не умножать строки заказа. */
WITH OrderLines AS
(
    SELECT SalesOrderID, COUNT(*) AS LineCount,
           SUM(OrderQty) AS Units, SUM(LineTotal) AS GoodsAmount
    FROM Sales.SalesOrderDetail
    GROUP BY SalesOrderID
)
SELECT TOP (30) h.SalesOrderID, h.OrderDate, c.AccountNumber,
       l.LineCount, l.Units, l.GoodsAmount, h.TotalDue
FROM Sales.SalesOrderHeader AS h
JOIN Sales.Customer AS c ON c.CustomerID = h.CustomerID
JOIN OrderLines AS l ON l.SalesOrderID = h.SalesOrderID
ORDER BY h.SalesOrderID DESC;
GO

/* 3. Практический: выручка по категориям за 2013 год. */
SELECT pc.Name AS Category, SUM(d.OrderQty) AS Units, SUM(d.LineTotal) AS Revenue
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
JOIN Production.Product AS p ON p.ProductID = d.ProductID
JOIN Production.ProductSubcategory AS ps
  ON ps.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Production.ProductCategory AS pc
  ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE h.OrderDate >= '20130101' AND h.OrderDate < '20140101'
GROUP BY pc.Name
ORDER BY Revenue DESC;
GO
