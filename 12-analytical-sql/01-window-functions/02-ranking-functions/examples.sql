/* Ранжирующие оконные функции. */
USE AdventureWorks2014;
GO
/* 1. Простой: ROW_NUMBER нумерует заказы клиента. */
SELECT CustomerID, SalesOrderID, OrderDate,
       ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID) AS OrderNumber
FROM Sales.SalesOrderHeader
ORDER BY CustomerID, OrderDate, SalesOrderID;
GO

/* 2. Продвинутый: RANK учитывает ничьи, DENSE_RANK не оставляет пропусков. */
SELECT ProductID, ListPrice,
       RANK() OVER (ORDER BY ListPrice DESC) AS PriceRank,
       DENSE_RANK() OVER (ORDER BY ListPrice DESC) AS DensePriceRank
FROM Production.Product
WHERE ListPrice > 0;
GO

/* 3. Практический: три последних заказа каждого клиента. */
WITH RankedOrders AS
(
    SELECT CustomerID, SalesOrderID, OrderDate, TotalDue,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, SalesOrderID DESC) AS rn
    FROM Sales.SalesOrderHeader
)
SELECT CustomerID, SalesOrderID, OrderDate, TotalDue
FROM RankedOrders
WHERE rn <= 3
ORDER BY CustomerID, rn;
GO
