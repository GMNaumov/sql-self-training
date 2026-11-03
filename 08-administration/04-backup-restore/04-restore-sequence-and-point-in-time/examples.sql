/* Последовательность восстановления: выполнять только на AW_RestoreLab. */
/* 1. Простой: прочитать состав backup без восстановления. */
/*
RESTORE HEADERONLY FROM DISK = N'E:\SqlLabBackups\AW_full_lab.bak';
RESTORE FILELISTONLY FROM DISK = N'E:\SqlLabBackups\AW_full_lab.bak';
*/
GO

/* 2. Продвинутый: full + differential, база остаётся NORECOVERY до журналов. */
/*
RESTORE DATABASE AW_RestoreLab
FROM DISK = N'E:\SqlLabBackups\AW_full_lab.bak'
WITH MOVE N'AdventureWorks2014_Data' TO N'E:\SqlLabData\AW_RestoreLab.mdf',
     MOVE N'AdventureWorks2014_Log' TO N'E:\SqlLabData\AW_RestoreLab_log.ldf',
     NORECOVERY, REPLACE, CHECKSUM;
RESTORE DATABASE AW_RestoreLab
FROM DISK = N'E:\SqlLabBackups\AW_diff_lab.bak'
WITH NORECOVERY, CHECKSUM;
*/
GO

/* 3. Практический: STOPAT выбирают по времени до ошибочного изменения. */
/*
RESTORE LOG AW_RestoreLab
FROM DISK = N'E:\SqlLabBackups\AW_log_lab.trn'
WITH STOPAT = '2024-05-20T12:45:00', RECOVERY;
*/
GO
/* Дата учебная; REPLACE опасен и никогда не должен указывать на рабочую базу. */
