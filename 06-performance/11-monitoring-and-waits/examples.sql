/* Мониторинг запросов и ожиданий. */
/* 1. Простой: текущие исполняемые запросы. */
SELECT r.session_id, r.status, r.cpu_time, r.logical_reads,
       r.wait_type, r.blocking_session_id
FROM sys.dm_exec_requests AS r
WHERE r.session_id <> @@SPID;
GO

/* 2. Продвинутый: накопленные ожидания экземпляра после последнего сброса/запуска. */
SELECT TOP (20) wait_type, waiting_tasks_count, wait_time_ms,
       wait_time_ms * 1.0 / NULLIF(waiting_tasks_count, 0) AS AvgWaitMs
FROM sys.dm_os_wait_stats
WHERE wait_type NOT LIKE N'SLEEP%'
ORDER BY wait_time_ms DESC;
GO

/* 3. Практический: самые ресурсоёмкие запросы по CPU из кэша планов. */
SELECT TOP (20) qs.execution_count,
       qs.total_worker_time / 1000.0 AS TotalCpuMs,
       qs.total_logical_reads,
       DB_NAME(st.dbid) AS DatabaseName,
       SUBSTRING(st.text, qs.statement_start_offset / 2 + 1,
                 ((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
                   ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2) + 1) AS StatementText
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_worker_time DESC;
GO
