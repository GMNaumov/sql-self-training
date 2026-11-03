/* Нарастающие итоги. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: накопление продаж по датам. */
SELECT d.FullDateAlternateKey AS SaleDate,
       SUM(f.SalesAmount) AS DailySales,
       SUM(SUM(f.SalesAmount)) OVER
       (ORDER BY d.FullDateAlternateKey ROWS UNBOUNDED PRECEDING) AS RunningSales
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d ON d.DateKey = f.OrderDateKey
GROUP BY d.FullDateAlternateKey
ORDER BY d.FullDateAlternateKey;
GO

/* 2. Продвинутый: отдельный итог для каждого года с детерминированным порядком. */
WITH DailySales AS
(
    SELECT OrderDateKey, SUM(SalesAmount) AS SalesAmount
    FROM dbo.FactInternetSales
    GROUP BY OrderDateKey
)
SELECT OrderDateKey, SalesAmount,
       SUM(SalesAmount) OVER
       (PARTITION BY OrderDateKey / 10000 ORDER BY OrderDateKey ROWS UNBOUNDED PRECEDING) AS RunningSales
FROM DailySales
ORDER BY OrderDateKey;
GO

/* 3. Практический: остаток по банковским проводкам. */
CREATE TABLE #Entry (EntryID int PRIMARY KEY, AccountID int, Amount decimal(19,4));
INSERT #Entry VALUES (1, 101, 1000.00), (2, 101, -125.50), (3, 101, 40.00);
SELECT EntryID, AccountID, Amount,
       SUM(Amount) OVER (PARTITION BY AccountID ORDER BY EntryID ROWS UNBOUNDED PRECEDING) AS Balance
FROM #Entry
ORDER BY EntryID;
DROP TABLE #Entry;
GO
