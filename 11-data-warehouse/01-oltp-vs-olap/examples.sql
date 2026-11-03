/* Сравнение OLTP-запроса и аналитической агрегации. */
/* 1. Простой: OLTP возвращает один операционный заказ. */
USE AdventureWorks2014;
GO
SELECT SalesOrderID, CustomerID, OrderDate, Status, TotalDue
FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43659;
GO

/* 2. Продвинутый: OLAP-отчёт агрегирует факт по измерениям. */
USE AdventureWorksDW2014;
GO
SELECT d.CalendarYear, p.EnglishProductName,
       SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
JOIN dbo.DimProduct AS p ON p.ProductKey = f.ProductKey
GROUP BY d.CalendarYear, p.EnglishProductName
ORDER BY d.CalendarYear, SalesAmount DESC;
GO

/* 3. Практический: банковский отчёт по месяцам не меняет операционные счета. */
SELECT d.CalendarYear, d.MonthNumberOfYear,
       COUNT(*) AS SalesRows, SUM(f.SalesAmount) AS Amount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear
ORDER BY d.CalendarYear, d.MonthNumberOfYear;
GO
