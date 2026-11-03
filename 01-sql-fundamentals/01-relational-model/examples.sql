/* Реляционная модель: строки, ключи и связи. */
USE AdventureWorks2014;
GO
/* 1. Простой: первичный ключ однозначно определяет товар. */
SELECT ProductID, ProductNumber, Name
FROM Production.Product
WHERE ProductID = 707;
GO

/* 2. Продвинутый: увидеть декларированную связь «заказ — позиции». */
SELECT fk.name AS ForeignKeyName,
       OBJECT_NAME(fk.parent_object_id) AS ChildTable,
       OBJECT_NAME(fk.referenced_object_id) AS ParentTable
FROM sys.foreign_keys AS fk
WHERE fk.parent_object_id = OBJECT_ID(N'Sales.SalesOrderDetail')
ORDER BY fk.name;
GO

/* 3. Практический: контроль ссылочной целостности позиций заказа. */
SELECT TOP (20) d.SalesOrderID, d.SalesOrderDetailID, d.ProductID
FROM Sales.SalesOrderDetail AS d
LEFT JOIN Production.Product AS p ON p.ProductID = d.ProductID
WHERE p.ProductID IS NULL;

-- Внешний ключ должен делать результат пустым; его наличие проверяют отдельно.
SELECT COUNT(*) AS DeclaredProductForeignKeys
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID(N'Sales.SalesOrderDetail')
  AND referenced_object_id = OBJECT_ID(N'Production.Product');
GO
