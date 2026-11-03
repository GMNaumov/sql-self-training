/* OUTER JOIN. */
USE AdventureWorks2014;
GO
/* 1. Простой: сохранить все товары, даже без продаж. */
SELECT TOP (30) p.ProductID, p.Name, d.SalesOrderID
FROM Production.Product AS p
LEFT JOIN Sales.SalesOrderDetail AS d ON d.ProductID = p.ProductID
ORDER BY p.ProductID, d.SalesOrderID;
GO

/* 2. Продвинутый: антисоединение ищет отсутствующие совпадения. */
SELECT p.ProductID, p.Name, p.ListPrice
FROM Production.Product AS p
LEFT JOIN Sales.SalesOrderDetail AS d ON d.ProductID = p.ProductID
WHERE d.ProductID IS NULL
  AND p.SellEndDate IS NULL
ORDER BY p.ListPrice DESC, p.ProductID;

-- Условие по правой таблице в WHERE превратило бы LEFT JOIN во INNER JOIN,
-- если бы отсекало NULL. Здесь IS NULL намеренно оставляет только несовпадения.
GO

/* 3. Практический: покупатели без заказов в 2014 году для кампании реактивации. */
SELECT c.CustomerID, c.AccountNumber, p.FirstName, p.LastName
FROM Sales.Customer AS c
LEFT JOIN Person.Person AS p ON p.BusinessEntityID = c.PersonID
WHERE NOT EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS h
    WHERE h.CustomerID = c.CustomerID
      AND h.OrderDate >= '20140101' AND h.OrderDate < '20150101'
)
ORDER BY c.CustomerID;
GO
