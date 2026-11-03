/* OVER, PARTITION BY и ORDER BY. */
USE AdventureWorks2014;
GO
/* 1. Простой: сумма по клиенту рядом с каждым заказом. */
SELECT SalesOrderID, CustomerID, SubTotal,
       SUM(SubTotal) OVER (PARTITION BY CustomerID) AS CustomerTotal
FROM Sales.SalesOrderHeader
ORDER BY CustomerID, SalesOrderID;
GO

/* 2. Продвинутый: ORDER BY в окне задаёт нарастающий итог. */
SELECT SalesOrderID, CustomerID, OrderDate, SubTotal,
       SUM(SubTotal) OVER
       (PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM Sales.SalesOrderHeader
WHERE CustomerID IN (11000, 11001)
ORDER BY CustomerID, OrderDate, SalesOrderID;
GO

/* 3. Практический: доля каждой продажи в обороте клиента. */
SELECT SalesOrderID, CustomerID, SubTotal,
       SubTotal * 100.0 / NULLIF(SUM(SubTotal) OVER (PARTITION BY CustomerID), 0) AS PercentOfCustomer
FROM Sales.SalesOrderHeader
ORDER BY CustomerID, SalesOrderID;
GO
