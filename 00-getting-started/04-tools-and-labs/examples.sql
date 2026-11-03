/* Инструменты и лаборатории: файл можно выполнить в SSMS или через sqlcmd. */

/* 1. Простой: единые настройки читаемого учебного результата. */
SET NOCOUNT ON;
USE AdventureWorks2014;
SELECT TOP (5) ProductID, Name, ListPrice
FROM Production.Product
ORDER BY ProductID;
GO

/* 2. Продвинутый: собрать логические чтения и время конкретного запроса. */
USE AdventureWorks2014;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT CustomerID, COUNT(*) AS OrderCount, SUM(TotalDue) AS TotalAmount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY CustomerID;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
-- Показатели зависят от стенда; не используйте один прогон как универсальный эталон.
GO

/* 3. Практический: безопасный лабораторный запуск с откатом изменения. */
USE AdventureWorks2014;

-- Временная копия позволяет проверить логику, не меняя исходную таблицу.
SELECT TOP (20) ProductID, Name, ListPrice
INTO #ProductPriceLab
FROM Production.Product
ORDER BY ProductID;

BEGIN TRANSACTION;
UPDATE #ProductPriceLab
SET ListPrice = ListPrice * 1.05
WHERE ListPrice > 0;

SELECT ProductID, ListPrice
FROM #ProductPriceLab
ORDER BY ProductID;

ROLLBACK TRANSACTION;
DROP TABLE #ProductPriceLab;
GO
