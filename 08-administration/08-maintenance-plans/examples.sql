/* Планы обслуживания: проверяем результат каждой операции. */
/* 1. Простой: статистика, обновлённая вручную на учебной копии. */
/* UPDATE STATISTICS AdventureWorks2014.Sales.SalesOrderHeader; */
GO

/* 2. Продвинутый: выбор больших фрагментированных индексов без автоматической перестройки. */
USE AdventureWorks2014;
GO
SELECT TOP (20) OBJECT_NAME(ips.object_id) AS TableName,
       i.name AS IndexName, ips.page_count, ips.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
WHERE ips.page_count >= 100
ORDER BY ips.avg_fragmentation_in_percent DESC;
GO

/* 3. Практический: контроль заданий обслуживания и сроков backup. */
SELECT j.name AS JobName, j.enabled,
       MAX(msdb.dbo.agent_datetime(h.run_date, h.run_time)) AS LastRun
FROM msdb.dbo.sysjobs AS j
LEFT JOIN msdb.dbo.sysjobhistory AS h ON h.job_id = j.job_id AND h.step_id = 0
GROUP BY j.name, j.enabled
ORDER BY j.name;
GO
/* Не запускайте REINDEX и CHECKDB одновременно на одном наборе данных без оценки нагрузки. */
