/* Типы данных SQL Server 2014. */
/* 1. Простой: тип литерала и переменной влияет на результат. */
DECLARE @Whole int = 5,
        @Exact decimal(10,2) = 5.00,
        @Text nvarchar(20) = N'Велосипед';
SELECT @Whole / 2 AS IntegerDivision,
       @Exact / 2 AS DecimalDivision,
       @Text AS UnicodeText;
GO

/* 2. Продвинутый: точность, масштаб и явное преобразование. */
DECLARE @Amount decimal(9,2) = 123.45,
        @Rate decimal(9,4) = 0.0825;
SELECT @Amount * @Rate AS CalculatedValue,
       CAST(@Amount * @Rate AS decimal(9,2)) AS RoundedMoney,
       CAST(N'2014-07-01' AS date) AS OrderDate;

-- TRY_CAST появился позже SQL Server 2014; проверяйте формат до CAST.
SELECT CASE WHEN ISNUMERIC(N'123.45') = 1
            THEN CAST(N'123.45' AS decimal(9,2)) END AS ParsedValue;
GO

/* 3. Практический: денежный расчёт без приближённого float. */
USE AdventureWorks2014;
GO
SELECT TOP (20) ProductID,
       CAST(ListPrice AS decimal(19,4)) AS ListPrice,
       CAST(ListPrice * 0.10 AS decimal(19,4)) AS Discount,
       CAST(ListPrice * 0.90 AS decimal(19,4)) AS FinalPrice
FROM Production.Product
WHERE ListPrice > 0
ORDER BY ProductID;
GO
