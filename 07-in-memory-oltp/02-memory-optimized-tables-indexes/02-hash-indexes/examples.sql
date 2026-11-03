/* Hash-индексы In-Memory OLTP 2014. Постоянный пример требует SqlTraining с LabMemory. */
/* 1. Простой: hash подходит для точечного равенства по AccountID. */
/*
USE SqlTraining;
GO
CREATE TABLE dbo.LabAccountState
(
    AccountID int NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 4096),
    Balance decimal(19,4) NOT NULL
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
*/
GO

/* 2. Продвинутый: статистика bucket count помогает увидеть пустые и длинные цепочки. */
SELECT OBJECT_NAME(h.object_id) AS TableName, i.name AS IndexName,
       h.total_bucket_count, h.empty_bucket_count, h.avg_chain_length, h.max_chain_length
FROM sys.dm_db_xtp_hash_index_stats AS h
JOIN sys.indexes AS i ON i.object_id = h.object_id AND i.index_id = h.index_id
ORDER BY avg_chain_length DESC;
GO

/* 3. Практический: равенство использует hash; диапазону нужен range-индекс. */
/*
SELECT AccountID, Balance FROM dbo.LabAccountState WHERE AccountID = 101;
-- Не ожидайте эффективного seek hash-индекса для WHERE AccountID > 100.
*/
GO
