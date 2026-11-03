/* Staging и ETL: загрузка во временные учебные таблицы. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: staging отделяет исходные строки от публикации. */
CREATE TABLE #SalesStage
(
    SalesOrderNumber nvarchar(20) NOT NULL,
    OrderDateKey int NOT NULL,
    ProductKey int NOT NULL,
    SalesAmount money NOT NULL
);
INSERT #SalesStage
SELECT TOP (100) SalesOrderNumber, OrderDateKey, ProductKey, SalesAmount
FROM dbo.FactInternetSales;
SELECT COUNT(*) AS StageRows FROM #SalesStage;
GO

/* 2. Продвинутый: ошибки ключей выявляются до загрузки факта. */
SELECT s.SalesOrderNumber, s.OrderDateKey, s.ProductKey,
       CASE WHEN d.DateKey IS NULL THEN N'Нет даты'
            WHEN p.ProductKey IS NULL THEN N'Нет продукта'
            ELSE N'Готово' END AS ValidationResult
FROM #SalesStage AS s
LEFT JOIN dbo.DimDate AS d ON d.DateKey = s.OrderDateKey
LEFT JOIN dbo.DimProduct AS p ON p.ProductKey = s.ProductKey
WHERE d.DateKey IS NULL OR p.ProductKey IS NULL;
GO

/* 3. Практический: контрольные суммы и количество строк до публикации. */
SELECT COUNT(*) AS [RowCount], SUM(SalesAmount) AS SalesAmount,
       MIN(OrderDateKey) AS MinDateKey, MAX(OrderDateKey) AS MaxDateKey
FROM #SalesStage;
DROP TABLE #SalesStage;
GO
/* Публикация постоянного факта должна быть транзакционной и идемпотентной по BatchID/ключу. */
