/* CROSS APPLY и OUTER APPLY. */
USE AdventureWorks2014;
GO
/* 1. Простой: три самых дорогих товара в каждой подкатегории. */
SELECT ps.Name AS Subcategory, x.ProductID, x.Name, x.ListPrice
FROM Production.ProductSubcategory AS ps
CROSS APPLY
(
    SELECT TOP (3) p.ProductID, p.Name, p.ListPrice
    FROM Production.Product AS p
    WHERE p.ProductSubcategoryID = ps.ProductSubcategoryID
      AND p.ListPrice > 0
    ORDER BY p.ListPrice DESC, p.ProductID
) AS x
ORDER BY ps.Name, x.ListPrice DESC, x.ProductID;
GO

/* 2. Продвинутый: OUTER APPLY сохраняет покупателя без заказа. */
SELECT TOP (50) c.CustomerID, c.AccountNumber,
       x.SalesOrderID AS LastOrderID, x.OrderDate AS LastOrderDate
FROM Sales.Customer AS c
OUTER APPLY
(
    SELECT TOP (1) h.SalesOrderID, h.OrderDate
    FROM Sales.SalesOrderHeader AS h
    WHERE h.CustomerID = c.CustomerID
    ORDER BY h.OrderDate DESC, h.SalesOrderID DESC
) AS x
ORDER BY x.OrderDate DESC, c.CustomerID;
GO

/* 3. Практический: последняя цена продажи каждого товара. */
SELECT TOP (50) p.ProductID, p.Name, x.LastSaleDate, x.LastUnitPrice
FROM Production.Product AS p
CROSS APPLY
(
    SELECT TOP (1) h.OrderDate AS LastSaleDate, d.UnitPrice AS LastUnitPrice
    FROM Sales.SalesOrderDetail AS d
    JOIN Sales.SalesOrderHeader AS h ON h.SalesOrderID = d.SalesOrderID
    WHERE d.ProductID = p.ProductID
    ORDER BY h.OrderDate DESC, h.SalesOrderID DESC, d.SalesOrderDetailID DESC
) AS x
ORDER BY x.LastSaleDate DESC, p.ProductID;
GO
