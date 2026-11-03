/* Доставка журналов (log shipping). */
USE msdb;
GO
/* 1. Простой: настроенные primary-базы. */
SELECT primary_database, backup_directory,
       backup_retention_period, monitor_server
FROM dbo.log_shipping_primary_databases;
GO

/* 2. Продвинутый: вторичные базы и задержки restore. */
SELECT secondary_database,
       last_restored_file, last_restored_date
FROM dbo.log_shipping_secondary_databases;
GO

/* 3. Практический: мониторинг ошибок доставки и копирования. */
SELECT TOP (50) database_name, agent_type, session_status, log_time, message
FROM dbo.log_shipping_monitor_history_detail
ORDER BY log_time DESC;
GO
/* Для аварийного восстановления нужен отдельный план tail-log, restore и переключения приложений. */
