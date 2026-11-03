/* DMV и текущая активность. */
/* 1. Простой: кто подключён и какой запрос выполняется. */
SELECT r.session_id, s.login_name, r.status, r.command,
       r.cpu_time, r.logical_reads, t.text
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s ON s.session_id = r.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE r.session_id <> @@SPID;
GO

/* 2. Продвинутый: блокировки и продолжительность транзакций. */
SELECT st.session_id, st.transaction_id, at.transaction_begin_time,
       DATEDIFF(second, at.transaction_begin_time, SYSDATETIME()) AS DurationSeconds,
       at.transaction_state, at.transaction_type
FROM sys.dm_tran_session_transactions AS st
JOIN sys.dm_tran_active_transactions AS at ON at.transaction_id = st.transaction_id
ORDER BY at.transaction_begin_time;
GO

/* 3. Практический: запросы с наибольшим числом логических чтений. */
SELECT TOP (20) qs.execution_count,
       qs.total_logical_reads, qs.total_logical_reads * 1.0 / qs.execution_count AS AvgReads,
       st.text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY qs.total_logical_reads DESC;
GO
