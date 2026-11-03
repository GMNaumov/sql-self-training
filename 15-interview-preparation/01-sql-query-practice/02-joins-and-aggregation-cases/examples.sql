/* Задачи на соединения и агрегирование. */
USE AdventureWorks2014;
GO
/* 1. Простой: сумма продаж по товарам, включая товары без продаж. */
SELECT p.ProductID, p.Name,
       COUNT(d.SalesOrderDetailID) AS SaleLineCount,
       ISNULL(SUM(d.LineTotal), 0) AS SalesAmount
FROM Production.Product AS p
LEFT JOIN Sales.SalesOrderDetail AS d ON d.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY SalesAmount DESC, p.ProductID;
GO

/* 2. Продвинутый: заказы, у которых рассчитанный SubTotal расходится с позициями. */
SELECT h.SalesOrderID, h.SubTotal, SUM(d.LineTotal) AS LinesTotal,
       SUM(d.LineTotal) - h.SubTotal AS Difference
FROM Sales.SalesOrderHeader AS h
JOIN Sales.SalesOrderDetail AS d ON d.SalesOrderID = h.SalesOrderID
GROUP BY h.SalesOrderID, h.SubTotal
HAVING ABS(SUM(d.LineTotal) - h.SubTotal) > 0.01;
GO

/* 3. Практический: продажи по категориям без размножения строк факта. */
SELECT pc.Name AS CategoryName,
       SUM(d.OrderQty) AS Quantity, SUM(d.LineTotal) AS SalesAmount
FROM Sales.SalesOrderDetail AS d
JOIN Production.Product AS p ON p.ProductID = d.ProductID
JOIN Production.ProductSubcategory AS ps ON ps.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Production.ProductCategory AS pc ON pc.ProductCategoryID = ps.ProductCategoryID
GROUP BY pc.Name
ORDER BY SalesAmount DESC;
GO
