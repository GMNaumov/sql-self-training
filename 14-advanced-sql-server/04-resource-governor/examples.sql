/* Resource Governor: чтение конфигурации, изменение — отдельная лаборатория. */
/* 1. Простой: пулы ресурсов и рабочие группы. */
SELECT name AS PoolName, min_cpu_percent, max_cpu_percent,
       min_memory_percent, max_memory_percent
FROM sys.resource_governor_resource_pools;
SELECT name AS GroupName, pool_id, importance,
       request_max_cpu_time_sec, request_max_memory_grant_percent
FROM sys.resource_governor_workload_groups;
GO

/* 2. Продвинутый: фактическое распределение активных запросов по группам. */
SELECT wg.name AS WorkloadGroup, r.session_id, r.status,
       r.cpu_time, r.granted_query_memory
FROM sys.dm_exec_requests AS r
JOIN sys.resource_governor_workload_groups AS wg ON wg.group_id = r.group_id;
GO

/* 3. Практический: шаблон ограничения отчётной нагрузки. */
/*
CREATE RESOURCE POOL LabReportPool WITH (MAX_CPU_PERCENT = 30, MAX_MEMORY_PERCENT = 30);
CREATE WORKLOAD GROUP LabReports USING LabReportPool;
-- Классификатор должен быть детерминированной scalar UDF, созданной в master.
ALTER RESOURCE GOVERNOR RECONFIGURE;
*/
GO
/* Проверьте классификацию тестовыми сеансами; не отключайте группы internal/default. */
