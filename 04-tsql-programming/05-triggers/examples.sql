/* DML-триггеры. Постоянные объекты предназначены для SqlTraining, не для AdventureWorks. */
USE SqlTraining;
GO
/* 1. Простой: аудит должен обрабатывать inserted/deleted как наборы строк. */
IF OBJECT_ID(N'dbo.LabAccount', N'U') IS NOT NULL DROP TABLE dbo.LabAccount;
CREATE TABLE dbo.LabAccount
(
    AccountID int NOT NULL PRIMARY KEY,
    Balance decimal(19,4) NOT NULL CHECK (Balance >= 0)
);
CREATE TABLE dbo.LabAccountAudit
(
    AuditID int IDENTITY(1,1) PRIMARY KEY,
    AccountID int NOT NULL,
    OldBalance decimal(19,4) NOT NULL,
    NewBalance decimal(19,4) NOT NULL,
    ChangedAt datetime2 NOT NULL DEFAULT SYSDATETIME()
);
GO
CREATE TRIGGER dbo.TR_LabAccount_Audit ON dbo.LabAccount
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT dbo.LabAccountAudit (AccountID, OldBalance, NewBalance)
    SELECT d.AccountID, d.Balance, i.Balance
    FROM deleted AS d
    JOIN inserted AS i ON i.AccountID = d.AccountID;
END;
GO

/* 2. Продвинутый: откат всего изменения при любом отрицательном остатке. */
IF OBJECT_ID(N'dbo.TR_LabAccount_Validate', N'TR') IS NOT NULL DROP TRIGGER dbo.TR_LabAccount_Validate;
GO
CREATE TRIGGER dbo.TR_LabAccount_Validate ON dbo.LabAccount
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM inserted WHERE Balance < 0)
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50010, 'Отрицательный остаток запрещён.', 1;
    END;
END;
GO
INSERT dbo.LabAccount VALUES (1, 100.00), (2, 200.00);
UPDATE dbo.LabAccount SET Balance = Balance + 25.00; -- аудит получит две строки.
SELECT * FROM dbo.LabAccountAudit;
GO

/* 3. Практический: триггер не заменяет CHECK и не должен делать медленные внешние вызовы. */
BEGIN TRY
    UPDATE dbo.LabAccount SET Balance = -1.00 WHERE AccountID = 1;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
SELECT AccountID, Balance FROM dbo.LabAccount ORDER BY AccountID;
GO
