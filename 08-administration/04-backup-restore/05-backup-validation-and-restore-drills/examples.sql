/* Проверка backup и учебное восстановление. */
/* 1. Простой: VERIFYONLY проверяет читаемость набора, но не заменяет restore. */
/*
RESTORE VERIFYONLY FROM DISK = N'E:\SqlLabBackups\AW_full_lab.bak' WITH CHECKSUM;
*/
GO

/* 2. Продвинутый: история restore помогает связать тест с исходными копиями. */
SELECT TOP (20) destination_database_name, restore_date, restore_type,
       replace, recovery
FROM msdb.dbo.restorehistory
WHERE destination_database_name = N'AW_RestoreLab'
ORDER BY restore_date DESC;
GO

/* 3. Практический: после учебного restore проверить целостность и контрольные данные. */
/*
DBCC CHECKDB (N'AW_RestoreLab') WITH NO_INFOMSGS, ALL_ERRORMSGS;
SELECT COUNT(*) AS OrderCount FROM AW_RestoreLab.Sales.SalesOrderHeader;
*/
GO
/* Успешный backup сам по себе не доказывает достижимость RTO. */
