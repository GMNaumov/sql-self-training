/* Базовый SELECT. */
USE AdventureWorks2014;
GO
/* 1. Простой: выбрать только нужные столбцы. */
SELECT ProductID, Name, ListPrice
FROM Production.Product;
GO

/* 2. Продвинутый: псевдонимы и вычисляемые выражения не меняют таблицу. */
SELECT p.ProductID,
       p.Name AS ProductName,
       pc.Name AS CategoryName,
       p.ListPrice,
       p.ListPrice - p.StandardCost AS EstimatedMargin
FROM Production.Product AS p
LEFT JOIN Production.ProductSubcategory AS ps
  ON ps.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS pc
  ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE p.ListPrice > 0
ORDER BY EstimatedMargin DESC, p.ProductID;
GO

/* 3. Практический: прайс-лист для менеджера по продажам. */
SELECT TOP (50) p.ProductNumber,
       p.Name AS ProductName,
       ISNULL(pc.Name, N'Без категории') AS Category,
       p.ListPrice,
       p.SellStartDate
FROM Production.Product AS p
LEFT JOIN Production.ProductSubcategory AS ps
  ON ps.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS pc
  ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE p.SellEndDate IS NULL
  AND p.ListPrice > 0
ORDER BY p.SellStartDate DESC, p.ProductID;
GO
