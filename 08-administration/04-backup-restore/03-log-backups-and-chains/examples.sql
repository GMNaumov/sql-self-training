/* Резервные копии журнала и непрерывность LSN-цепочки. */
/* 1. Простой: модель FULL/BULK_LOGGED допускает log backup. */
SELECT name, recovery_model_desc, log_reuse_wait_desc
FROM sys.databases
WHERE name = N'AdventureWorks2014';
GO

/* 2. Продвинутый: история LSN показывает порядок восстановления журналов. */
SELECT TOP (30) backup_finish_date, first_lsn, last_lsn,
       checkpoint_lsn, database_backup_lsn
FROM msdb.dbo.backupset
WHERE database_name = N'AdventureWorks2014' AND type = 'L'
ORDER BY first_lsn;
GO

/* 3. Практический: резервирование журнала в новый учебный файл. */
/*
BACKUP LOG AdventureWorks2014
TO DISK = N'E:\SqlLabBackups\AW_log_lab.trn'
WITH CHECKSUM, COMPRESSION;
*/
GO
/* Если цепочка не начата или модель SIMPLE, команда завершится ошибкой — это диагностический признак. */
