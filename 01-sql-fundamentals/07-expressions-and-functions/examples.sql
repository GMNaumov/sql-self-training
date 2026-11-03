/* Выражения и встроенные функции. */
USE AdventureWorks2014;
GO
/* 1. Простой: строковые, числовые функции и работа с NULL. */
SELECT ProductNumber,
       UPPER(Name) AS UpperName,
       LEN(Name) AS NameLength,
       ISNULL(Color, N'Не указан') AS DisplayColor,
       ROUND(ListPrice, 0) AS RoundedPrice
FROM Production.Product
ORDER BY ProductID;
GO

/* 2. Продвинутый: календарные границы и безопасное деление. */
DECLARE @MonthStart date = '20140101';
SELECT DATEADD(month, 1, @MonthStart) AS NextMonthStart,
       DATEDIFF(day, @MonthStart, DATEADD(month, 1, @MonthStart)) AS DaysInMonth;

SELECT SalesOrderID,
       SUM(OrderQty) AS Quantity,
       SUM(LineTotal) AS Amount,
       SUM(LineTotal) / NULLIF(SUM(OrderQty), 0) AS AmountPerUnit
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY SalesOrderID;
GO

/* 3. Практический: оценка маржи проданных позиций. */
SELECT TOP (50) d.SalesOrderID, p.ProductID, p.Name,
       d.OrderQty,
       d.LineTotal - d.OrderQty * p.StandardCost AS EstimatedGrossProfit
FROM Sales.SalesOrderDetail AS d
JOIN Production.Product AS p ON p.ProductID = d.ProductID
WHERE d.OrderQty > 0
ORDER BY EstimatedGrossProfit DESC, d.SalesOrderDetailID;
GO
