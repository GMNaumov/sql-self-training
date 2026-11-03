/* Счётчики производительности и базовая линия. */
/* 1. Простой: Page life expectancy и Batch Requests из DMV. */
SELECT counter_name, object_name, instance_name, cntr_value, cntr_type
FROM sys.dm_os_performance_counters
WHERE counter_name IN (N'Page life expectancy', N'Batch Requests/sec')
ORDER BY counter_name, instance_name;
GO

/* 2. Продвинутый: накопленные ожидания требуют двух замеров через интервал. */
CREATE TABLE #WaitBaseline
(
    wait_type nvarchar(60) NOT NULL,
    waiting_tasks_count bigint NOT NULL,
    wait_time_ms bigint NOT NULL
);
INSERT #WaitBaseline
SELECT wait_type, waiting_tasks_count, wait_time_ms FROM sys.dm_os_wait_stats;
WAITFOR DELAY '00:00:05';
SELECT w.wait_type,
       w.waiting_tasks_count - b.waiting_tasks_count AS TasksDelta,
       w.wait_time_ms - b.wait_time_ms AS WaitMsDelta
FROM sys.dm_os_wait_stats AS w
JOIN #WaitBaseline AS b ON b.wait_type = w.wait_type
WHERE w.wait_time_ms > b.wait_time_ms
ORDER BY WaitMsDelta DESC;
DROP TABLE #WaitBaseline;
GO

/* 3. Практический: нагрузка по базам из кэша запросов для сравнения с baseline. */
SELECT TOP (20) DB_NAME(st.dbid) AS DatabaseName,
       SUM(qs.total_worker_time) / 1000.0 AS TotalCpuMs,
       SUM(qs.total_logical_reads) AS TotalReads,
       SUM(qs.execution_count) AS Executions
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
GROUP BY DB_NAME(st.dbid)
ORDER BY TotalCpuMs DESC;
GO
