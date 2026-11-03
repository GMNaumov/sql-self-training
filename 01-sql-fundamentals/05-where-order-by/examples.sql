/* WHERE и ORDER BY. */
USE AdventureWorks2014;
GO
/* 1. Простой: полуоткрытый диапазон включает весь январь 2014 года. */
SELECT SalesOrderID, OrderDate, CustomerID, TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20140101' AND OrderDate < '20140201'
ORDER BY OrderDate, SalesOrderID;
GO

/* 2. Продвинутый: скобки фиксируют приоритет AND и OR. */
SELECT ProductID, Name, Color, ListPrice, SafetyStockLevel
FROM Production.Product
WHERE (Color = N'Red' OR Color = N'Black')
  AND ListPrice BETWEEN 100 AND 1000
  AND SafetyStockLevel >= 10
ORDER BY ListPrice DESC, ProductID;
GO

/* 3. Практический: очередь крупных заказов за последний доступный месяц. */
DECLARE @FromDate date = '20140601',
        @ToDate date = '20140701';

SELECT TOP (100) h.SalesOrderID, h.OrderDate, h.CustomerID,
       h.TotalDue, h.Status
FROM Sales.SalesOrderHeader AS h
WHERE h.OrderDate >= @FromDate
  AND h.OrderDate < @ToDate
  AND h.TotalDue >= 10000
ORDER BY h.TotalDue DESC, h.SalesOrderID;
GO
