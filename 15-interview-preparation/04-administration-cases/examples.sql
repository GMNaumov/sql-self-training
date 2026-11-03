/* Кейсы администрирования: диагностика до исправления. */
/* 1. Простой: модель восстановления и причина роста журнала. */
SELECT name, recovery_model_desc, log_reuse_wait_desc
FROM sys.databases
WHERE name = N'AdventureWorks2014';
GO

/* 2. Продвинутый: последние backup всех типов. */
SELECT TOP (30) database_name, type, backup_start_date, backup_finish_date,
       first_lsn, last_lsn, compressed_backup_size
FROM msdb.dbo.backupset
WHERE database_name = N'AdventureWorks2014'
ORDER BY backup_finish_date DESC;
GO

/* 3. Практический: восстановление после ошибочного DELETE требует известного времени и цепочки. */
/*
RESTORE VERIFYONLY FROM DISK = N'E:\SqlLabBackups\AW_full_lab.bak' WITH CHECKSUM;
-- Далее restore в AW_RestoreLab с NORECOVERY и log STOPAT, затем CHECKDB и контрольный SELECT.
SELECT COUNT(*) AS Orders FROM AW_RestoreLab.Sales.SalesOrderHeader;
*/
GO
/* Не выбирайте REPAIR_ALLOW_DATA_LOSS как универсальный ответ на повреждение. */
