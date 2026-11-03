/* Транзакции и устойчивость In-Memory OLTP. */
/* 1. Простой: различить durable и schema-only таблицы. */
SELECT s.name AS SchemaName, t.name AS TableName, t.durability_desc
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
WHERE t.is_memory_optimized = 1;
GO

/* 2. Продвинутый: активные транзакции XTP и их состояние. */
SELECT xt.transaction_id, xt.state_desc, xt.begin_tsn, xt.end_tsn
FROM sys.dm_db_xtp_transactions AS xt
ORDER BY xt.transaction_id;
GO

/* 3. Практический: конфликт optimistic concurrency обрабатывается retry. */
DECLARE @Attempt int = 1, @Succeeded bit = 0;
WHILE @Attempt <= 3 AND @Succeeded = 0
BEGIN
    BEGIN TRY
        /* Вызов заранее созданной native-процедуры в SqlTraining:
           EXEC dbo.LabSetOrderStatus @OrderID = 1, @Status = 3; */
        SET @Succeeded = 1;
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() NOT IN (41302, 41305, 41325, 41301) OR @Attempt = 3 THROW;
        SET @Attempt += 1;
    END CATCH;
END;
SELECT @Attempt AS Attempts, @Succeeded AS Succeeded;
GO
