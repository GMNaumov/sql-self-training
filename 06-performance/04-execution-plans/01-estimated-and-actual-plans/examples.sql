/* Оценочный и фактический планы выполнения. */
USE AdventureWorks2014;
GO
/* 1. Простой: SHOWPLAN_XML возвращает оценочный план без выполнения запроса. */
SET SHOWPLAN_XML ON;
GO
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;
GO
SET SHOWPLAN_XML OFF;
GO

/* 2. Продвинутый: STATISTICS XML выполняет запрос и добавляет фактические метрики. */
SET STATISTICS XML ON;
GO
SELECT h.CustomerID, COUNT(*) AS OrderCount, SUM(h.SubTotal) AS SalesAmount
FROM Sales.SalesOrderHeader AS h
WHERE h.OrderDate >= '20130101' AND h.OrderDate < '20140101'
GROUP BY h.CustomerID;
GO
SET STATISTICS XML OFF;
GO

/* 3. Практический: IO и время дополняют фактический план отчёта. */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT p.ProductID, p.Name, SUM(d.LineTotal) AS Revenue
FROM Sales.SalesOrderDetail AS d
JOIN Production.Product AS p ON p.ProductID = d.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY Revenue DESC;
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO
