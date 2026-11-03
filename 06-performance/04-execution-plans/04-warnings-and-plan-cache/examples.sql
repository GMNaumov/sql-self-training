/* Предупреждения планов и кэш планов. */
/* 1. Простой: текст и число использований кэшированного плана. */
SELECT TOP (20) cp.usecounts, cp.cacheobjtype, st.text
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
ORDER BY cp.usecounts DESC;
GO

/* 2. Продвинутый: найти предупреждения непосредственно в XML плана. */
SELECT TOP (20) qs.execution_count, st.text AS QueryText, qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE CAST(qp.query_plan AS nvarchar(max)) LIKE N'%<Warnings%'
ORDER BY qs.total_worker_time DESC;
GO

/* 3. Практический: статистика конкретного оператора в кэше без очистки всего сервера. */
SELECT TOP (20) qs.plan_handle, qs.execution_count,
       qs.total_worker_time / 1000.0 AS TotalCpuMs,
       qs.total_logical_reads, qp.query_plan
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE qp.dbid = DB_ID(N'AdventureWorks2014')
ORDER BY qs.total_logical_reads DESC;
GO
/* Не используйте DBCC FREEPROCCACHE на рабочем сервере ради «настройки» одного запроса. */
