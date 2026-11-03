/* Стратегия резервного копирования: RPO и RTO. */
/* 1. Простой: модель восстановления и время последних backup. */
SELECT d.name AS DatabaseName, d.recovery_model_desc,
       MAX(CASE WHEN b.type = 'D' THEN b.backup_finish_date END) AS LastFull,
       MAX(CASE WHEN b.type = 'L' THEN b.backup_finish_date END) AS LastLog
FROM sys.databases AS d
LEFT JOIN msdb.dbo.backupset AS b ON b.database_name = d.name
WHERE d.name = N'AdventureWorks2014'
GROUP BY d.name, d.recovery_model_desc;
GO

/* 2. Продвинутый: цепочка событий резервного копирования для оценки RPO. */
SELECT TOP (30) database_name, type, backup_start_date, backup_finish_date,
       first_lsn, last_lsn, backup_size
FROM msdb.dbo.backupset
WHERE database_name = N'AdventureWorks2014'
ORDER BY backup_start_date DESC;
GO

/* 3. Практический: учебный backup не должен перезаписывать исходные .bak проекта. */
/*
BACKUP DATABASE AdventureWorks2014
TO DISK = N'E:\SqlLabBackups\AW_strategy_full.bak'
WITH CHECKSUM, COMPRESSION;
*/
GO
/* RTO проверяется только учебным восстановлением и измерением всех этапов. */
