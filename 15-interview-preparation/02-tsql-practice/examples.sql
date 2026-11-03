/* Практика T-SQL: решения и граничные случаи. */
/* 1. Простой: процедурная логика и параметр. */
DECLARE @CustomerID int = 11000;
SELECT SalesOrderID, OrderDate, SubTotal
FROM AdventureWorks2014.Sales.SalesOrderHeader
WHERE CustomerID = @CustomerID
ORDER BY OrderDate, SalesOrderID;
GO

/* 2. Продвинутый: безопасный dynamic SQL с параметром. */
DECLARE @ProductID int = 707;
DECLARE @sql nvarchar(max) =
    N'SELECT SalesOrderID, OrderQty, LineTotal
      FROM AdventureWorks2014.Sales.SalesOrderDetail
      WHERE ProductID = @ProductID;';
EXEC sys.sp_executesql @sql, N'@ProductID int', @ProductID = @ProductID;
GO

/* 3. Практический: атомарный перевод с контролем существования обоих счетов. */
CREATE TABLE #Account (AccountID int PRIMARY KEY, Balance decimal(19,4) NOT NULL CHECK (Balance >= 0));
INSERT #Account VALUES (1, 500.00), (2, 100.00);
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE #Account WITH (UPDLOCK, HOLDLOCK) SET Balance = Balance - 100.00
    WHERE AccountID = 1 AND Balance >= 100.00;
    IF @@ROWCOUNT <> 1 THROW 50201, 'Недостаточно средств или нет счёта.', 1;
    UPDATE #Account SET Balance = Balance + 100.00 WHERE AccountID = 2;
    IF @@ROWCOUNT <> 1 THROW 50202, 'Счёт получателя не найден.', 1;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
SELECT * FROM #Account ORDER BY AccountID;
DROP TABLE #Account;
GO
