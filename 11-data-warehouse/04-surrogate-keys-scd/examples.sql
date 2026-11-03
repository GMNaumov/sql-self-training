/* Суррогатные ключи и история SCD. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: ProductKey отличается от бизнес-кода ProductAlternateKey. */
SELECT TOP (20) ProductKey, ProductAlternateKey, EnglishProductName,
       StartDate, EndDate, Status
FROM dbo.DimProduct
ORDER BY ProductKey;
GO

/* 2. Продвинутый: найти версии одного товара (SCD Type 2). */
SELECT ProductKey, ProductAlternateKey, EnglishProductName,
       StandardCost, StartDate, EndDate, Status
FROM dbo.DimProduct
WHERE ProductAlternateKey = N'BK-R93R-62'
ORDER BY StartDate, ProductKey;
GO

/* 3. Практический: выбор версии клиента на дату операции в учебной модели. */
CREATE TABLE #CustomerVersion
(
    CustomerKey int NOT NULL, CustomerNumber nvarchar(20) NOT NULL,
    Segment nvarchar(20) NOT NULL, ValidFrom date NOT NULL, ValidTo date NULL
);
INSERT #CustomerVersion VALUES
(1, N'C001', N'Standard', '20230101', '20231231'),
(2, N'C001', N'VIP', '20240101', NULL);
DECLARE @OperationDate date = '20240215';
SELECT CustomerKey, CustomerNumber, Segment
FROM #CustomerVersion
WHERE CustomerNumber = N'C001'
  AND @OperationDate >= ValidFrom
  AND (@OperationDate < ValidTo OR ValidTo IS NULL);
DROP TABLE #CustomerVersion;
GO
