/* INSERT: все изменения выполняются во временных таблицах. */
/* 1. Простой: явный список столбцов и несколько строк. */
CREATE TABLE #ProductTag (ProductID int NOT NULL, Tag nvarchar(30) NOT NULL);
INSERT #ProductTag (ProductID, Tag)
VALUES (707, N'Новинка'), (707, N'Для города'), (708, N'Новинка');
SELECT * FROM #ProductTag ORDER BY ProductID, Tag;
DROP TABLE #ProductTag;
GO

/* 2. Продвинутый: INSERT ... SELECT и OUTPUT сохраняют добавленные строки. */
CREATE TABLE #ExpensiveProduct (ProductID int NOT NULL, ProductName nvarchar(50) NOT NULL);
USE AdventureWorks2014;
INSERT #ExpensiveProduct (ProductID, ProductName)
OUTPUT inserted.ProductID, inserted.ProductName
SELECT TOP (10) ProductID, Name
FROM Production.Product
WHERE ListPrice > 2000
ORDER BY ListPrice DESC, ProductID;
SELECT * FROM #ExpensiveProduct ORDER BY ProductID;
DROP TABLE #ExpensiveProduct;
GO

/* 3. Практический: загрузка только проверенных строк из staging. */
CREATE TABLE #IncomingPayment
(
    PaymentReference nvarchar(20) NOT NULL,
    Amount decimal(19,4) NOT NULL,
    CustomerID int NULL
);
CREATE TABLE #Payment
(
    PaymentReference nvarchar(20) NOT NULL PRIMARY KEY,
    Amount decimal(19,4) NOT NULL,
    CustomerID int NOT NULL,
    LoadedAt datetime2(0) NOT NULL DEFAULT SYSDATETIME()
);
INSERT #IncomingPayment VALUES (N'P-001', 100.00, 11000), (N'P-002', -50.00, 11001),
                              (N'P-003', 80.00, NULL);
INSERT #Payment (PaymentReference, Amount, CustomerID)
SELECT i.PaymentReference, i.Amount, i.CustomerID
FROM #IncomingPayment AS i
WHERE i.Amount > 0 AND i.CustomerID IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM #Payment AS p WHERE p.PaymentReference = i.PaymentReference);
SELECT * FROM #Payment;
SELECT * FROM #IncomingPayment AS i
WHERE NOT EXISTS (SELECT 1 FROM #Payment AS p WHERE p.PaymentReference = i.PaymentReference);
DROP TABLE #Payment;
DROP TABLE #IncomingPayment;
GO
