/* Операторы плана: seek, scan, join, lookup. */
USE AdventureWorks2014;
GO
/* 1. Простой: равенство по ключу обычно позволяет Index Seek. */
SET STATISTICS XML ON;
SELECT SalesOrderID, CustomerID, OrderDate
FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43659;
SET STATISTICS XML OFF;
GO

/* 2. Продвинутый: соединение и агрегат формируют дерево операторов. */
SET STATISTICS XML ON;
SELECT p.ProductID, p.Name, SUM(d.OrderQty) AS Quantity
FROM Production.Product AS p
JOIN Sales.SalesOrderDetail AS d ON d.ProductID = p.ProductID
WHERE p.ProductID = 707
GROUP BY p.ProductID, p.Name;
SET STATISTICS XML OFF;
GO

/* 3. Практический: INCLUDE может убрать Key Lookup для узкого отчёта. */
SELECT i.name AS IndexName, c.name AS IncludedColumn
FROM sys.indexes AS i
JOIN sys.index_columns AS ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id
JOIN sys.columns AS c ON c.object_id = ic.object_id AND c.column_id = ic.column_id
WHERE i.object_id = OBJECT_ID(N'Sales.SalesOrderHeader')
  AND ic.is_included_column = 1
ORDER BY i.name, c.name;
GO
