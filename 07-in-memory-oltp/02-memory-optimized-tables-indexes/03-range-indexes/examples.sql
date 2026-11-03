/* Range-индексы memory-optimized таблиц SQL Server 2014. */
/* 1. Простой: диапазон по дате требует NONCLUSTERED, а не HASH. */
/*
USE SqlTraining;
GO
CREATE TABLE dbo.LabPayment
(
    PaymentID bigint NOT NULL PRIMARY KEY NONCLUSTERED,
    AccountID int NOT NULL,
    PaidAt datetime2 NOT NULL,
    Amount decimal(19,4) NOT NULL,
    INDEX IX_LabPayment_PaidAt NONCLUSTERED (PaidAt)
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
*/
GO

/* 2. Продвинутый: обнаружить range-индексы существующих таблиц. */
SELECT OBJECT_NAME(h.object_id) AS TableName, i.name AS IndexName
FROM sys.hash_indexes AS h
JOIN sys.indexes AS i ON i.object_id = h.object_id AND i.index_id = h.index_id
WHERE i.type_desc = N'NONCLUSTERED';
GO
SELECT OBJECT_NAME(i.object_id) AS TableName, i.name AS IndexName, i.type_desc
FROM sys.indexes AS i
WHERE i.type = 7; -- NONCLUSTERED index памяти в SQL Server 2014.
GO

/* 3. Практический: отчёт по платежам за закрытый диапазон времени. */
/*
SELECT PaymentID, AccountID, PaidAt, Amount
FROM dbo.LabPayment
WHERE PaidAt >= '20240101' AND PaidAt < '20240201'
ORDER BY PaidAt, PaymentID;
*/
GO
