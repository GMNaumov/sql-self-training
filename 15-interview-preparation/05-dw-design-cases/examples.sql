/* Кейсы проектирования хранилища данных. */
USE AdventureWorksDW2014;
GO
/* 1. Простой: зерно факта и аддитивная мера. */
SELECT SalesOrderNumber, SalesOrderLineNumber,
       ProductKey, OrderDateKey, OrderQuantity, SalesAmount
FROM dbo.FactInternetSales
WHERE SalesOrderNumber = N'SO43697';
GO

/* 2. Продвинутый: SCD Type 2 выбирает версию на дату события. */
CREATE TABLE #DimCustomer
(
    CustomerKey int NOT NULL, CustomerNumber nvarchar(20) NOT NULL,
    Segment nvarchar(20) NOT NULL, ValidFrom date NOT NULL, ValidTo date NULL
);
INSERT #DimCustomer VALUES (1, N'C1', N'Standard', '20230101', '20240101'),
                           (2, N'C1', N'VIP', '20240101', NULL);
DECLARE @SaleDate date = '20240201';
SELECT CustomerKey, Segment FROM #DimCustomer
WHERE CustomerNumber = N'C1' AND @SaleDate >= ValidFrom
  AND (@SaleDate < ValidTo OR ValidTo IS NULL);
DROP TABLE #DimCustomer;
GO

/* 3. Практический: контроль ETL по строкам и сумме. */
SELECT COUNT(*) AS FactRows, SUM(SalesAmount) AS SalesAmount,
       COUNT(DISTINCT SalesOrderNumber) AS OrderCount
FROM dbo.FactInternetSales;
GO
/* В решении назовите зерно, ключи, SCD, инкремент, идемпотентность и сверку. */
