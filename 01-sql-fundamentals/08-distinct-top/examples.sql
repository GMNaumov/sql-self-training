/* DISTINCT, TOP и ограничение результата. */
USE AdventureWorks2014;
GO
/* 1. Простой: уникальные цвета, включая NULL как одно значение. */
SELECT DISTINCT Color
FROM Production.Product
ORDER BY Color;
GO

/* 2. Продвинутый: WITH TIES возвращает всех с такой же ценой. */
SELECT TOP (5) WITH TIES ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice > 0
ORDER BY ListPrice DESC;

-- Для точного количества и детерминированности добавьте уникальный второй ключ:
SELECT TOP (5) ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice > 0
ORDER BY ListPrice DESC, ProductID;
GO

/* 3. Практический: последний заказ каждого из десяти активных покупателей. */
WITH CustomerOrders AS
(
    SELECT h.CustomerID, h.SalesOrderID, h.OrderDate, h.TotalDue,
           ROW_NUMBER() OVER
           (
               PARTITION BY h.CustomerID
               ORDER BY h.OrderDate DESC, h.SalesOrderID DESC
           ) AS rn
    FROM Sales.SalesOrderHeader AS h
)
SELECT TOP (10) CustomerID, SalesOrderID, OrderDate, TotalDue
FROM CustomerOrders
WHERE rn = 1
ORDER BY OrderDate DESC, CustomerID;
GO
