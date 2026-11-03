/* Курсоры и наборная обработка. */
USE AdventureWorks2014;
GO
/* 1. Простой: наборный расчёт вместо построчного обновления. */
SELECT ProductID, Name, ListPrice,
       ROUND(ListPrice * 1.05, 2) AS NewListPrice
FROM Production.Product
WHERE ListPrice > 0;
GO

/* 2. Продвинутый: курсор оправдан для административной команды по каждой базе. */
DECLARE @DatabaseName sysname, @sql nvarchar(max);
DECLARE database_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT name FROM sys.databases
    WHERE name IN (N'AdventureWorks2014', N'AdventureWorksDW2014')
    ORDER BY name;
OPEN database_cursor;
FETCH NEXT FROM database_cursor INTO @DatabaseName;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = N'ALTER DATABASE ' + QUOTENAME(@DatabaseName) + N' SET COMPATIBILITY_LEVEL = 120;';
    PRINT @sql; -- Сначала проверьте текст; EXEC здесь намеренно не выполняется.
    FETCH NEXT FROM database_cursor INTO @DatabaseName;
END;
CLOSE database_cursor;
DEALLOCATE database_cursor;
GO

/* 3. Практический: наборное начисление копеечного кэшбэка по категориям заказов. */
WITH CustomerSales AS
(
    SELECT h.CustomerID, SUM(d.LineTotal) AS SalesAmount
    FROM Sales.SalesOrderHeader AS h
    JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
    WHERE h.OrderDate >= '20130101' AND h.OrderDate < '20140101'
    GROUP BY h.CustomerID
)
SELECT CustomerID, SalesAmount,
       CAST(SalesAmount * CASE WHEN SalesAmount >= 10000 THEN 0.03 ELSE 0.01 END AS decimal(19,2)) AS Cashback
FROM CustomerSales
ORDER BY CustomerID;
GO
