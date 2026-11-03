/* Хранимые процедуры. Выполняйте в отдельной учебной базе SqlTraining. */
USE SqlTraining;
GO
/* 1. Простой: параметризованное чтение заказов. */
IF OBJECT_ID(N'dbo.GetCustomerOrders', N'P') IS NOT NULL DROP PROCEDURE dbo.GetCustomerOrders;
GO
CREATE PROCEDURE dbo.GetCustomerOrders
    @CustomerID int,
    @FromDate date = '20000101'
AS
BEGIN
    SET NOCOUNT ON;
    SELECT SalesOrderID, OrderDate, SubTotal
    FROM AdventureWorks2014.Sales.SalesOrderHeader
    WHERE CustomerID = @CustomerID AND OrderDate >= @FromDate
    ORDER BY OrderDate, SalesOrderID;
END;
GO
EXEC dbo.GetCustomerOrders @CustomerID = 11000, @FromDate = '20130101';
GO

/* 2. Продвинутый: OUTPUT-параметр и код возврата имеют разное назначение. */
IF OBJECT_ID(N'dbo.GetOrderTotal', N'P') IS NOT NULL DROP PROCEDURE dbo.GetOrderTotal;
GO
CREATE PROCEDURE dbo.GetOrderTotal
    @SalesOrderID int,
    @Total money OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @Total = SubTotal
    FROM AdventureWorks2014.Sales.SalesOrderHeader
    WHERE SalesOrderID = @SalesOrderID;
    IF @@ROWCOUNT = 0 RETURN 1;
    RETURN 0;
END;
GO
DECLARE @Total money, @Result int;
EXEC @Result = dbo.GetOrderTotal @SalesOrderID = 43659, @Total = @Total OUTPUT;
SELECT @Result AS ReturnCode, @Total AS OrderTotal;
GO

/* 3. Практический: атомарное списание с блокировкой строки счёта. */
CREATE TABLE #Account (AccountID int PRIMARY KEY, Balance decimal(19,4) NOT NULL CHECK (Balance >= 0));
INSERT #Account VALUES (1, 500.00);
GO
CREATE PROCEDURE #Withdraw
    @AccountID int,
    @Amount decimal(19,4)
AS
BEGIN
    SET NOCOUNT ON;
    IF @Amount <= 0 THROW 50002, 'Сумма должна быть положительной.', 1;
    BEGIN TRANSACTION;
    UPDATE #Account WITH (UPDLOCK, HOLDLOCK)
    SET Balance = Balance - @Amount
    WHERE AccountID = @AccountID AND Balance >= @Amount;
    IF @@ROWCOUNT = 0
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50003, 'Счёт не найден или средств недостаточно.', 1;
    END;
    COMMIT TRANSACTION;
END;
GO
EXEC #Withdraw @AccountID = 1, @Amount = 125.00;
SELECT * FROM #Account;
DROP PROCEDURE #Withdraw;
DROP TABLE #Account;
GO
