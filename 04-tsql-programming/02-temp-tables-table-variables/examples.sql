/* Временные таблицы и табличные переменные. */
USE AdventureWorks2014;
GO
/* 1. Простой: табличная переменная живёт до конца пакета. */
DECLARE @SelectedStatus table (Status tinyint NOT NULL PRIMARY KEY);
INSERT @SelectedStatus VALUES (1), (5);
SELECT h.SalesOrderID, h.OrderDate, h.Status
FROM Sales.SalesOrderHeader AS h
JOIN @SelectedStatus AS s ON s.Status = h.Status
WHERE h.OrderDate >= '20140101';
GO

/* 2. Продвинутый: #table поддерживает явный индекс и статистику. */
CREATE TABLE #LargeCustomers
(
    CustomerID int NOT NULL PRIMARY KEY,
    SalesAmount money NOT NULL
);
INSERT #LargeCustomers
SELECT h.CustomerID, SUM(h.SubTotal)
FROM Sales.SalesOrderHeader AS h
GROUP BY h.CustomerID
HAVING SUM(h.SubTotal) >= 100000;

SELECT c.CustomerID, c.SalesAmount, p.FirstName, p.LastName
FROM #LargeCustomers AS c
JOIN Person.Person AS p ON p.BusinessEntityID = c.CustomerID
ORDER BY c.SalesAmount DESC;
DROP TABLE #LargeCustomers;
GO

/* 3. Практический: staging-проверка банковских проводок до публикации. */
CREATE TABLE #PaymentBatch
(
    PaymentID int NOT NULL PRIMARY KEY,
    AccountID int NOT NULL,
    Amount decimal(19,4) NOT NULL,
    CurrencyCode char(3) NOT NULL
);
INSERT #PaymentBatch VALUES (1, 101, 125.50, 'RUB'), (2, 101, -10.00, 'RUB');
SELECT PaymentID,
       CASE WHEN Amount <= 0 THEN N'Некорректная сумма'
            WHEN CurrencyCode <> 'RUB' THEN N'Некорректная валюта'
            ELSE N'Готово' END AS ValidationResult
FROM #PaymentBatch;
DROP TABLE #PaymentBatch;
GO
