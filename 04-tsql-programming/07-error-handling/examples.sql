/* Обработка ошибок и транзакций. */
/* 1. Простой: TRY/CATCH возвращает сведения об ошибке. */
BEGIN TRY
    SELECT 1 / 0 AS InvalidResult;
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,
           ERROR_MESSAGE() AS ErrorMessage,
           ERROR_LINE() AS ErrorLine;
END CATCH;
GO

/* 2. Продвинутый: XACT_STATE отличает активную и нефиксируемую транзакцию. */
CREATE TABLE #Account (AccountID int PRIMARY KEY, Balance decimal(19,4) NOT NULL CHECK (Balance >= 0));
INSERT #Account VALUES (1, 100.00);
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE #Account SET Balance = Balance - 150.00 WHERE AccountID = 1;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    SELECT XACT_STATE() AS TransactionStateAfterRollback, ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
SELECT * FROM #Account;
DROP TABLE #Account;
GO

/* 3. Практический: повторная попытка только для взаимоблокировки (ошибка 1205). */
DECLARE @Attempt int = 1, @MaxAttempts int = 3;
WHILE @Attempt <= @MaxAttempts
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        /* Здесь вызывается наборная бизнес-операция учебного приложения. */
        WAITFOR DELAY '00:00:00.010';
        COMMIT TRANSACTION;
        PRINT N'Операция подтверждена.';
        BREAK;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        IF ERROR_NUMBER() = 1205 AND @Attempt < @MaxAttempts
        BEGIN
            SET @Attempt += 1;
            WAITFOR DELAY '00:00:00.100';
            CONTINUE;
        END;
        THROW; -- SQL Server 2014 сохраняет исходную ошибку при повторном THROW.
    END CATCH;
END;
GO
