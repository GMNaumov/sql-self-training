/* Оконные агрегаты и рамки. */
USE AdventureWorks2014;
GO
/* 1. Простой: средний чек клиента без GROUP BY. */
SELECT CustomerID, SalesOrderID, SubTotal,
       AVG(SubTotal) OVER (PARTITION BY CustomerID) AS AvgCustomerOrder
FROM Sales.SalesOrderHeader;
GO

/* 2. Продвинутый: разница ROWS и RANGE при повторяющихся датах. */
WITH Daily AS
(
    SELECT OrderDate, SUM(SubTotal) AS SalesAmount
    FROM Sales.SalesOrderHeader
    GROUP BY OrderDate
)
SELECT OrderDate, SalesAmount,
       SUM(SalesAmount) OVER (ORDER BY OrderDate ROWS UNBOUNDED PRECEDING) AS RowsRunningTotal
FROM Daily
ORDER BY OrderDate;
GO

/* 3. Практический: скользящая сумма последних трёх заказов клиента. */
SELECT CustomerID, SalesOrderID, OrderDate, SubTotal,
       SUM(SubTotal) OVER
       (PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS LastThreeOrdersTotal
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000
ORDER BY OrderDate, SalesOrderID;
GO
