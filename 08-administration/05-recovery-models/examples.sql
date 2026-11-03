/* Модели восстановления и повторное использование журнала. */
/* 1. Простой: текущая модель и причина удержания журнала. */
SELECT name, recovery_model_desc, log_reuse_wait_desc
FROM sys.databases
ORDER BY name;
GO

/* 2. Продвинутый: последний log backup нужен для проверки эксплуатационной цепочки. */
SELECT d.name AS DatabaseName, d.recovery_model_desc,
       MAX(b.backup_finish_date) AS LastLogBackup
FROM sys.databases AS d
LEFT JOIN msdb.dbo.backupset AS b
  ON b.database_name = d.name AND b.type = 'L'
WHERE d.database_id > 4
GROUP BY d.name, d.recovery_model_desc;
GO

/* 3. Практический: переход SIMPLE -> FULL требует нового full backup. */
/*
ALTER DATABASE AdventureWorks2014 SET RECOVERY FULL;
BACKUP DATABASE AdventureWorks2014
TO DISK = N'E:\SqlLabBackups\AW_after_full_model.bak'
WITH CHECKSUM, COMPRESSION;
*/
GO
/* Переключение модели само по себе не запускает цепочку log backup. */
