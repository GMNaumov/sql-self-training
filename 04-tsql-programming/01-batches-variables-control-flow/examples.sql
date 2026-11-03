/* Пакеты, переменные и управление потоком. */
USE AdventureWorks2014;
GO
/* 1. Простой: переменная и условие внутри одного пакета. */
DECLARE @MinimumPrice decimal(19,4) = 1000.00;
IF @MinimumPrice > 0
    SELECT ProductID, Name, ListPrice
    FROM Production.Product
    WHERE ListPrice >= @MinimumPrice
    ORDER BY ListPrice DESC;
ELSE
    PRINT N'Порог цены должен быть положительным.';
GO

/* 2. Продвинутый: WHILE формирует помесячный отчёт, а не изменяет строки по одной. */
DECLARE @Month date = '20130101', @EndMonth date = '20131201';
WHILE @Month <= @EndMonth
BEGIN
    SELECT @Month AS MonthStart,
           COUNT(*) AS OrderCount,
           SUM(h.SubTotal) AS SalesAmount
    FROM Sales.SalesOrderHeader AS h
    WHERE h.OrderDate >= @Month
      AND h.OrderDate < DATEADD(month, 1, @Month);
    SET @Month = DATEADD(month, 1, @Month);
END;
GO

/* 3. Практический: пакетная проверка заказа перед выдачей результата. */
DECLARE @SalesOrderID int = 43659;
IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
    THROW 50001, 'Заказ не найден.', 1; -- THROW доступен в SQL Server 2014.

SELECT h.SalesOrderID, h.OrderDate, h.Status,
       COUNT(d.SalesOrderDetailID) AS LineCount,
       SUM(d.LineTotal) AS CalculatedTotal
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
WHERE h.SalesOrderID = @SalesOrderID
GROUP BY h.SalesOrderID, h.OrderDate, h.Status;
GO
