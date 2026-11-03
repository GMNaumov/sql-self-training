/* Блокировки и ожидания. Диагностические запросы только читают метаданные. */
/* 1. Простой: активные запросы и их ожидания. */
SELECT r.session_id, r.status, r.wait_type, r.wait_time,
       r.blocking_session_id, t.text AS QueryText
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE r.session_id <> @@SPID;
GO

/* 2. Продвинутый: цепочка блокировок и объекты текущего экземпляра. */
SELECT wt.session_id AS WaitingSession,
       wt.blocking_session_id AS BlockingSession,
       wt.wait_duration_ms,
       wt.resource_description,
       DB_NAME(tl.resource_database_id) AS DatabaseName
FROM sys.dm_os_waiting_tasks AS wt
LEFT JOIN sys.dm_tran_locks AS tl
  ON tl.lock_owner_address = wt.resource_address
WHERE wt.blocking_session_id IS NOT NULL;
GO

/* 3. Практический: короткая транзакция с намёком на блокировку при списании. */
CREATE TABLE #Stock (ProductID int PRIMARY KEY, Quantity int NOT NULL);
INSERT #Stock VALUES (707, 10);
BEGIN TRANSACTION;
UPDATE #Stock WITH (UPDLOCK, ROWLOCK)
SET Quantity = Quantity - 1
WHERE ProductID = 707 AND Quantity > 0;
/* Бизнес-проверки выполняются внутри, долгие внешние вызовы — вне транзакции. */
COMMIT TRANSACTION;
SELECT * FROM #Stock;
DROP TABLE #Stock;
GO
