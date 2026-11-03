/* Взаимоблокировки: диагностика и единый порядок доступа. */
/* 1. Простой: текущие свойства сеанса, включая deadlock priority. */
SELECT session_id, deadlock_priority, transaction_isolation_level
FROM sys.dm_exec_sessions
WHERE session_id = @@SPID;
GO

/* 2. Продвинутый: системный Extended Events health содержит сведения о deadlock. */
SELECT CAST(target_data AS xml) AS HealthData
FROM sys.dm_xe_session_targets AS t
JOIN sys.dm_xe_sessions AS s ON s.address = t.event_session_address
WHERE s.name = N'system_health' AND t.target_name = N'ring_buffer';
GO

/* 3. Практический: обе операции обновляют счета в порядке идентификаторов. */
CREATE TABLE #Account (AccountID int PRIMARY KEY, Balance decimal(19,4) NOT NULL);
INSERT #Account VALUES (1, 100.00), (2, 100.00);
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE #Account SET Balance = Balance + 10.00 WHERE AccountID = 1;
    UPDATE #Account SET Balance = Balance - 10.00 WHERE AccountID = 2;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    IF ERROR_NUMBER() = 1205
        PRINT N'Жертва deadlock: после отката приложение может повторить операцию.';
    ELSE
        THROW;
END CATCH;
SELECT * FROM #Account ORDER BY AccountID;
DROP TABLE #Account;
GO
