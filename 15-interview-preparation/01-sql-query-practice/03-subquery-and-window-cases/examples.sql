/* Подзапросы и оконные функции на собеседовании. */
USE AdventureWorks2014;
GO
/* 1. Простой: клиенты, у которых есть заказы. */
SELECT c.CustomerID
FROM Sales.Customer AS c
WHERE EXISTS (SELECT 1 FROM Sales.SalesOrderHeader AS h WHERE h.CustomerID = c.CustomerID)
ORDER BY c.CustomerID;
GO

/* 2. Продвинутый: последний заказ каждого клиента с детерминированной нумерацией. */
WITH Ranked AS
(
    SELECT CustomerID, SalesOrderID, OrderDate, TotalDue,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, SalesOrderID DESC) AS rn
    FROM Sales.SalesOrderHeader
)
SELECT * FROM Ranked WHERE rn = 1 ORDER BY CustomerID;
GO

/* 3. Практический: прирост месячных продаж к предыдущему месяцу. */
WITH Monthly AS
(
    SELECT DATEADD(month, DATEDIFF(month, 0, OrderDate), 0) AS MonthStart,
           SUM(SubTotal) AS SalesAmount
    FROM Sales.SalesOrderHeader
    GROUP BY DATEADD(month, DATEDIFF(month, 0, OrderDate), 0)
), Compared AS
(
    SELECT MonthStart, SalesAmount,
           LAG(SalesAmount) OVER (ORDER BY MonthStart) AS PreviousAmount
    FROM Monthly
)
SELECT MonthStart, SalesAmount, PreviousAmount, SalesAmount - PreviousAmount AS Delta
FROM Compared
ORDER BY MonthStart;
GO
