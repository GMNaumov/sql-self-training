/* Parameter sniffing: оценка плана зависит от первого значения параметра. */
USE AdventureWorks2014;
GO
/* 1. Простой: два параметра могут иметь разную селективность. */
SELECT SalesOrderID, CustomerID, OrderDate
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;
SELECT SalesOrderID, CustomerID, OrderDate
FROM Sales.SalesOrderHeader
WHERE CustomerID = 29847;
GO

/* 2. Продвинутый: OPTIMIZE FOR UNKNOWN использует плотность, а не конкретное значение. */
DECLARE @CustomerID int = 11000;
SELECT SalesOrderID, CustomerID, OrderDate, SubTotal
FROM Sales.SalesOrderHeader
WHERE CustomerID = @CustomerID
OPTION (OPTIMIZE FOR UNKNOWN);
GO

/* 3. Практический: RECOMPILE — осознанная цена повторной компиляции для редкого отчёта. */
DECLARE @CustomerID int = 29847, @FromDate date = '20130101';
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = @CustomerID AND OrderDate >= @FromDate
OPTION (RECOMPILE);
GO
