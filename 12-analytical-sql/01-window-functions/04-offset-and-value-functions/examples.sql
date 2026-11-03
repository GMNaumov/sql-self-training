/* LAG, LEAD, FIRST_VALUE и LAST_VALUE. */
USE AdventureWorks2014;
GO
/* 1. Простой: предыдущий заказ клиента. */
SELECT CustomerID, SalesOrderID, OrderDate,
       LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID) AS PreviousOrderDate
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000
ORDER BY OrderDate, SalesOrderID;
GO

/* 2. Продвинутый: LAST_VALUE требует явной рамки до конца окна. */
WITH Daily AS
(
    SELECT OrderDate, SUM(SubTotal) AS SalesAmount
    FROM Sales.SalesOrderHeader
    GROUP BY OrderDate
)
SELECT OrderDate, SalesAmount,
       FIRST_VALUE(SalesAmount) OVER (ORDER BY OrderDate) AS FirstDayAmount,
       LAST_VALUE(SalesAmount) OVER
       (ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastDayAmount
FROM Daily
ORDER BY OrderDate;
GO

/* 3. Практический: число дней между покупками. */
WITH Ordered AS
(
    SELECT CustomerID, SalesOrderID, OrderDate,
           LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID) AS PreviousOrderDate
    FROM Sales.SalesOrderHeader
)
SELECT CustomerID, SalesOrderID, OrderDate,
       DATEDIFF(day, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder
FROM Ordered
WHERE PreviousOrderDate IS NOT NULL
ORDER BY CustomerID, OrderDate, SalesOrderID;
GO
