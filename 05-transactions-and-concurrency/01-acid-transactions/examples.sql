/* ACID и явные транзакции. */
/* 1. Простой: перевод подтверждается целиком или откатывается целиком. */
CREATE TABLE #Account (AccountID int PRIMARY KEY, Balance decimal(19,4) NOT NULL CHECK (Balance >= 0));
INSERT #Account VALUES (1, 500.00), (2, 100.00);
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE #Account SET Balance = Balance - 125.00 WHERE AccountID = 1;
    UPDATE #Account SET Balance = Balance + 125.00 WHERE AccountID = 2;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
SELECT * FROM #Account ORDER BY AccountID;
GO

/* 2. Продвинутый: точка сохранения не заменяет внешний COMMIT. */
BEGIN TRANSACTION;
UPDATE #Account SET Balance = Balance + 50.00 WHERE AccountID = 1;
SAVE TRANSACTION BeforeOptionalFee;
UPDATE #Account SET Balance = Balance - 20.00 WHERE AccountID = 1;
ROLLBACK TRANSACTION BeforeOptionalFee; -- отменена только комиссия.
COMMIT TRANSACTION;
SELECT * FROM #Account WHERE AccountID = 1;
DROP TABLE #Account;
GO

/* 3. Практический: запас списывается только при достаточном остатке. */
CREATE TABLE #Stock (ProductID int PRIMARY KEY, Quantity int NOT NULL CHECK (Quantity >= 0));
INSERT #Stock VALUES (707, 10);
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE #Stock WITH (UPDLOCK, HOLDLOCK)
    SET Quantity = Quantity - 3
    WHERE ProductID = 707 AND Quantity >= 3;
    IF @@ROWCOUNT = 0 THROW 50100, 'Недостаточно товара на складе.', 1;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
SELECT * FROM #Stock;
DROP TABLE #Stock;
GO
