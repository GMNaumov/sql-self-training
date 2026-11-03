/* Настройка запросов: сначала измерение, затем изменение. */
USE AdventureWorks2014;
GO
/* 1. Простой: выбрать только нужные столбцы и ограничить период. */
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT SalesOrderID, CustomerID, OrderDate, SubTotal
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101' AND OrderDate < '20140101';
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

/* 2. Продвинутый: сравнить EXISTS с дублирующим соединением. */
SELECT h.SalesOrderID, h.OrderDate
FROM Sales.SalesOrderHeader AS h
WHERE EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderDetail AS d
    WHERE d.SalesOrderID = h.SalesOrderID AND d.UnitPriceDiscount > 0
);
GO

/* 3. Практический: ежемесячный отчёт с одним проходом по деталям. */
WITH MonthlySales AS
(
    SELECT DATEADD(month, DATEDIFF(month, 0, h.OrderDate), 0) AS MonthStart,
           h.CustomerID, SUM(d.LineTotal) AS SalesAmount
    FROM Sales.SalesOrderHeader AS h
    JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
    WHERE h.OrderDate >= '20130101' AND h.OrderDate < '20140101'
    GROUP BY DATEADD(month, DATEDIFF(month, 0, h.OrderDate), 0), h.CustomerID
)
SELECT MonthStart, CustomerID, SalesAmount
FROM MonthlySales
ORDER BY MonthStart, CustomerID;
GO
