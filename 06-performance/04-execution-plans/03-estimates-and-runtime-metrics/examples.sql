/* Оценки и фактические метрики выполнения. */
USE AdventureWorks2014;
GO
/* 1. Простой: сравнить EstimatedRows и ActualRows в XML плана. */
SET STATISTICS XML ON;
SELECT SalesOrderID, CustomerID
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;
SET STATISTICS XML OFF;
GO

/* 2. Продвинутый: локальная переменная не даёт оптимизатору увидеть литерал при компиляции. */
DECLARE @CustomerID int = 11000;
SET STATISTICS XML ON;
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = @CustomerID;
SET STATISTICS XML OFF;
GO

/* 3. Практический: измерение логических чтений до и после изменения запроса. */
SET STATISTICS IO ON;
SELECT h.CustomerID, COUNT_BIG(*) AS OrderCount
FROM Sales.SalesOrderHeader AS h
WHERE h.OrderDate >= '20130101' AND h.OrderDate < '20140101'
GROUP BY h.CustomerID;
SET STATISTICS IO OFF;
GO
/* Сопоставляйте estimated/actual rows, чтения, время и повторяемость на одном наборе данных. */
