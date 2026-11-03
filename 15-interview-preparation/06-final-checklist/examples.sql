/* Итоговый практический чек-лист на локальном SQL Server 2014. */
/* 1. Простой: подтвердить целевую версию и базы. */
SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('Edition') AS Edition;
SELECT name, state_desc, compatibility_level
FROM sys.databases
WHERE name IN (N'AdventureWorks2014', N'AdventureWorksDW2014');
GO

/* 2. Продвинутый: последние два заказа каждого клиента. */
USE AdventureWorks2014;
GO
WITH Ranked AS
(
    SELECT CustomerID, SalesOrderID, OrderDate, TotalDue,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC, SalesOrderID DESC) AS rn
    FROM Sales.SalesOrderHeader
)
SELECT * FROM Ranked WHERE rn <= 2 ORDER BY CustomerID, rn;
GO

/* 3. Практический: безопасное списание остатка с транзакцией. */
CREATE TABLE #Account (AccountID int PRIMARY KEY, Balance decimal(19,4) NOT NULL CHECK (Balance >= 0));
INSERT #Account VALUES (1, 100.00);
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE #Account WITH (UPDLOCK, HOLDLOCK)
    SET Balance = Balance - 25.00
    WHERE AccountID = 1 AND Balance >= 25.00;
    IF @@ROWCOUNT <> 1 THROW 50300, 'Операция отклонена.', 1;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
SELECT * FROM #Account;
DROP TABLE #Account;
GO
