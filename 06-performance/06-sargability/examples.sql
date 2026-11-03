/* Sargability: условия, допускающие поиск по индексу. */
USE AdventureWorks2014;
GO
/* 1. Простой: диапазон дат вместо функции над столбцом. */
SELECT SalesOrderID, OrderDate, CustomerID
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101' AND OrderDate < '20140101';
GO

/* 2. Продвинутый: префиксный поиск допускает seek; ведущий % обычно его исключает. */
SELECT ProductID, ProductNumber, Name
FROM Production.Product
WHERE ProductNumber LIKE N'BK-%';
GO
SELECT ProductID, ProductNumber, Name
FROM Production.Product
WHERE ProductNumber LIKE N'%-R%'; -- Для сравнения плана и чтений.
GO

/* 3. Практический: номер счёта нормализуется параметром, а не функцией над данными. */
DECLARE @AccountNumber nvarchar(30) = N'AW00011000';
SELECT h.SalesOrderID, h.OrderDate, h.TotalDue
FROM Sales.SalesOrderHeader AS h
WHERE h.SalesOrderNumber = @AccountNumber;
GO
