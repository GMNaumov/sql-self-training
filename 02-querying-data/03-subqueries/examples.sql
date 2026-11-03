/* Подзапросы. */
USE AdventureWorks2014;
GO
/* 1. Простой: товары дороже средней ненулевой цены. */
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product WHERE ListPrice > 0)
ORDER BY ListPrice DESC, ProductID;
GO

/* 2. Продвинутый: EXISTS проверяет факт, NOT EXISTS — отсутствие. */
SELECT p.ProductID, p.Name
FROM Production.Product AS p
WHERE EXISTS
(
    SELECT 1 FROM Sales.SalesOrderDetail AS d
    WHERE d.ProductID = p.ProductID AND d.OrderQty >= 10
)
AND NOT EXISTS
(
    SELECT 1 FROM Production.ProductReview AS r
    WHERE r.ProductID = p.ProductID
)
ORDER BY p.ProductID;
GO

/* 3. Практический: клиенты, чья сумма покупок выше среднего клиентского итога. */
WITH CustomerTotals AS
(
    SELECT CustomerID, SUM(TotalDue) AS TotalAmount
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT TOP (50) CustomerID, TotalAmount
FROM CustomerTotals
WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM CustomerTotals)
ORDER BY TotalAmount DESC, CustomerID;
GO
