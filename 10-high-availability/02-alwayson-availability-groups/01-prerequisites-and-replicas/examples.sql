/* Предпосылки AG и реплики: только диагностика, топологию не меняем. */
/* 1. Простой: включён ли HADR на экземпляре. */
SELECT SERVERPROPERTY('IsHadrEnabled') AS IsHadrEnabled,
       SERVERPROPERTY('HadrManagerStatus') AS HadrManagerStatus;
GO

/* 2. Продвинутый: реплики, режимы доступности и подключения. */
SELECT ar.replica_server_name, ar.availability_mode_desc,
       ar.failover_mode_desc,
       ar.primary_role_allow_connections_desc, ar.secondary_role_allow_connections_desc
FROM sys.availability_replicas AS ar
ORDER BY ar.replica_server_name;
GO

/* 3. Практический: базы-кандидаты должны быть FULL и иметь log backup. */
SELECT d.name AS DatabaseName, d.recovery_model_desc,
       MAX(CASE WHEN b.type = 'L' THEN b.backup_finish_date END) AS LastLogBackup
FROM sys.databases AS d
LEFT JOIN msdb.dbo.backupset AS b ON b.database_name = d.name
WHERE d.database_id > 4
GROUP BY d.name, d.recovery_model_desc;
GO
/* В SQL Server 2014 нет automatic seeding: начальную синхронизацию выполняют backup/restore. */
