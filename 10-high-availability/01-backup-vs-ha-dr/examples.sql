/* Backup, HA и DR решают разные задачи. */
/* 1. Простой: наличие backup не равно состоянию реплики. */
SELECT d.name AS DatabaseName, d.recovery_model_desc,
       MAX(b.backup_finish_date) AS LastFullBackup
FROM sys.databases AS d
LEFT JOIN msdb.dbo.backupset AS b ON b.database_name = d.name AND b.type = 'D'
WHERE d.name = N'AdventureWorks2014'
GROUP BY d.name, d.recovery_model_desc;
GO

/* 2. Продвинутый: если AG настроена, проверить состояние синхронизации. */
SELECT ar.replica_server_name, ars.role_desc, ars.synchronization_health_desc,
       DB_NAME(adc.database_id) AS DatabaseName, adc.synchronization_state_desc
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS ars ON ars.replica_id = ar.replica_id
LEFT JOIN sys.dm_hadr_database_replica_states AS adc ON adc.replica_id = ar.replica_id
ORDER BY ar.replica_server_name, DatabaseName;
GO

/* 3. Практический: история restore подтверждает факт учения DR, а не наличие AG. */
SELECT TOP (20) destination_database_name, restore_date, restore_type
FROM msdb.dbo.restorehistory
ORDER BY restore_date DESC;
GO
