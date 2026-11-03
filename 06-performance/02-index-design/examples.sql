/* Проектирование индексов. Изменения выполняйте только на учебной копии. */
USE AdventureWorks2014;
GO
/* 1. Простой: покрытие фильтра по клиенту и дате. */
/* IF NOT EXISTS здесь проверяет метаданные; DROP IF EXISTS в 2014 отсутствует. */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Lab_SOH_Customer_OrderDate' AND object_id = OBJECT_ID(N'Sales.SalesOrderHeader'))
    CREATE NONCLUSTERED INDEX IX_Lab_SOH_Customer_OrderDate
    ON Sales.SalesOrderHeader (CustomerID, OrderDate)
    INCLUDE (SubTotal, SalesOrderID);
GO
SELECT SalesOrderID, OrderDate, SubTotal
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000 AND OrderDate >= '20130101';
GO

/* 2. Продвинутый: включённые столбцы устраняют lookup, не расширяя ключ поиска. */
SELECT i.name AS IndexName, c.name AS IncludedColumn
FROM sys.indexes AS i
JOIN sys.index_columns AS ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns AS c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
WHERE i.name = N'IX_Lab_SOH_Customer_OrderDate' AND ic.is_included_column = 1;
GO

/* 3. Практический: гипотеза индекса должна подтверждаться IO, а не только именем. */
SET STATISTICS IO ON;
SELECT SalesOrderID, OrderDate, SubTotal
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000 AND OrderDate >= '20130101' AND OrderDate < '20140101';
SET STATISTICS IO OFF;
GO
/* Уборка после лаборатории: DROP INDEX IX_Lab_SOH_Customer_OrderDate ON Sales.SalesOrderHeader; */
