/* Полные и разностные backup: команды не запускаются автоматически. */
/* 1. Простой: полная копия в отдельный учебный файл. */
/*
BACKUP DATABASE AdventureWorks2014
TO DISK = N'E:\SqlLabBackups\AW_full_lab.bak'
WITH CHECKSUM, COMPRESSION;
*/
GO

/* 2. Продвинутый: differential опирается на свою полную базу, не на предыдущий differential. */
/*
BACKUP DATABASE AdventureWorks2014
TO DISK = N'E:\SqlLabBackups\AW_diff_lab.bak'
WITH DIFFERENTIAL, CHECKSUM, COMPRESSION;
*/
GO
SELECT TOP (10) database_name, type, backup_finish_date,
       differential_base_lsn, differential_base_guid
FROM msdb.dbo.backupset
WHERE database_name = N'AdventureWorks2014' AND type IN ('D', 'I')
ORDER BY backup_finish_date DESC;
GO

/* 3. Практический: COPY_ONLY для внеплановой копии без смены differential base. */
/*
BACKUP DATABASE AdventureWorks2014
TO DISK = N'E:\SqlLabBackups\AW_copy_only.bak'
WITH COPY_ONLY, CHECKSUM, COMPRESSION;
*/
GO
