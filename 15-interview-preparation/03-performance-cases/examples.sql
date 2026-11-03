/* Кейсы производительности: измерить, объяснить, изменить. */
USE AdventureWorks2014;
GO
/* 1. Простой: sargable диапазон дат и логические чтения. */
SET STATISTICS IO ON;
SELECT SalesOrderID, CustomerID, OrderDate
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101' AND OrderDate < '20140101';
SET STATISTICS IO OFF;
GO

/* 2. Продвинутый: фактический план для сравнения оценок и факта. */
SET STATISTICS XML ON;
DECLARE @CustomerID int = 11000;
SELECT SalesOrderID, OrderDate, SubTotal
FROM Sales.SalesOrderHeader
WHERE CustomerID = @CustomerID
OPTION (RECOMPILE);
SET STATISTICS XML OFF;
GO

/* 3. Практический: EXISTS не размножает заголовок заказа. */
SELECT h.SalesOrderID, h.OrderDate, h.TotalDue
FROM Sales.SalesOrderHeader AS h
WHERE EXISTS
(
    SELECT 1 FROM Sales.SalesOrderDetail AS d
    WHERE d.SalesOrderID = h.SalesOrderID
      AND d.OrderQty >= 10
)
ORDER BY h.SalesOrderID;
GO
/* На собеседовании назовите гипотезу индекса и способ проверки, а не обещайте ускорение. */
