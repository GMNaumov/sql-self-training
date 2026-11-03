/* Базовые задачи SQL: фильтрация, сортировка и агрегация. */
USE AdventureWorks2014;
GO
/* 1. Простой: товары дороже порога. */
DECLARE @MinPrice decimal(19,4) = 1000.00;
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ListPrice >= @MinPrice
ORDER BY ListPrice DESC, ProductID;
GO

/* 2. Продвинутый: клиенты с оборотом выше порога и без потери нулевых заказов. */
SELECT h.CustomerID, COUNT(*) AS OrderCount, SUM(h.SubTotal) AS SalesAmount
FROM Sales.SalesOrderHeader AS h
GROUP BY h.CustomerID
HAVING SUM(h.SubTotal) > 100000
ORDER BY SalesAmount DESC, h.CustomerID;
GO

/* 3. Практический: прайс-лист активных товаров с категорией. */
SELECT p.ProductNumber, p.Name AS ProductName,
       ISNULL(pc.Name, N'Без категории') AS CategoryName, p.ListPrice
FROM Production.Product AS p
LEFT JOIN Production.ProductSubcategory AS ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS pc ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE p.SellEndDate IS NULL AND p.ListPrice > 0
ORDER BY CategoryName, p.Name;
GO
