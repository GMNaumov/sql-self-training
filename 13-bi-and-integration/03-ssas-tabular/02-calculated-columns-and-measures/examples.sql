/* SQL-эквиваленты вычисляемых столбцов и мер DAX. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: вычисляемый столбец стоимости строки. */
SELECT SalesOrderNumber, SalesOrderLineNumber,
       OrderQuantity, UnitPrice, SalesAmount,
       SalesAmount - TotalProductCost AS GrossMargin
FROM dbo.FactInternetSales;
GO

/* 2. Продвинутый: мера считает сумму в текущем фильтре года. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

/* 3. Практический: доля продажи в общем итоге как проверка DAX-меры. */
SELECT d.CalendarYear, SUM(f.SalesAmount) AS SalesAmount,
       SUM(f.SalesAmount) * 100.0 / SUM(SUM(f.SalesAmount)) OVER () AS SalesPercent
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO
/* DAX-меры и контекст фильтра приведены в examples.dax. */
