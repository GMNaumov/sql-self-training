/* Ключи и ограничения целостности. */
/* 1. Простой: PRIMARY KEY, CHECK и DEFAULT. */
CREATE TABLE #Account
(
    AccountID int NOT NULL PRIMARY KEY,
    Balance decimal(19,4) NOT NULL DEFAULT 0,
    CurrencyCode char(3) NOT NULL DEFAULT 'RUB',
    CONSTRAINT CK_Account_Balance CHECK (Balance >= 0)
);
INSERT #Account (AccountID, Balance) VALUES (1, 100.00);
SELECT * FROM #Account;
DROP TABLE #Account;
GO

/* 2. Продвинутый: внешний ключ и уникальность составного ключа. */
CREATE TABLE #Warehouse (WarehouseID int PRIMARY KEY, WarehouseName nvarchar(50) NOT NULL);
CREATE TABLE #Stock
(
    WarehouseID int NOT NULL REFERENCES #Warehouse(WarehouseID),
    ProductID int NOT NULL,
    Quantity int NOT NULL CHECK (Quantity >= 0),
    PRIMARY KEY (WarehouseID, ProductID)
);
INSERT #Warehouse VALUES (1, N'Основной');
INSERT #Stock VALUES (1, 707, 10);
BEGIN TRY
    INSERT #Stock VALUES (1, 707, 20); -- нарушение составного PK
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
DROP TABLE #Stock;
DROP TABLE #Warehouse;
GO

/* 3. Практический: транзакция не допускает отрицательный остаток. */
CREATE TABLE #BankAccount (AccountID int PRIMARY KEY, Balance decimal(19,4) NOT NULL CHECK (Balance >= 0));
INSERT #BankAccount VALUES (1, 50.00);
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE #BankAccount SET Balance = Balance - 100.00 WHERE AccountID = 1;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    SELECT ERROR_MESSAGE() AS RejectedChange;
END CATCH;
SELECT AccountID, Balance FROM #BankAccount; -- исходный остаток сохранился
DROP TABLE #BankAccount;
GO
