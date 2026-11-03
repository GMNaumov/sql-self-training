/* Восстановление AdventureWorks. Пути учебные; адаптируйте их к своему стенду. */

/* 1. Простой: узнать, восстановлены ли базы. */
SELECT name, state_desc, compatibility_level, recovery_model_desc
FROM sys.databases
WHERE name LIKE N'AdventureWorks%2014'
ORDER BY name;
GO

/* 2. Продвинутый: сначала прочитать состав копии, не восстанавливая её. */
-- RESTORE FILELISTONLY
-- FROM DISK = N'C:\SqlLabBackups\AdventureWorks2014.bak';

-- RESTORE HEADERONLY
-- FROM DISK = N'C:\SqlLabBackups\AdventureWorks2014.bak';
GO

/* 3. Практический: восстановление OLTP-базы с явным MOVE. */
-- Выполняйте только если базы AdventureWorks2014 ещё нет.
-- Логические имена возьмите из FILELISTONLY; не указывайте исходный .bak как выходной.
-- RESTORE DATABASE AdventureWorks2014
-- FROM DISK = N'C:\SqlLabBackups\AdventureWorks2014.bak'
-- WITH MOVE N'AdventureWorks2014_Data'
--          TO N'D:\SqlData\AdventureWorks2014_Data.mdf',
--      MOVE N'AdventureWorks2014_Log'
--          TO N'L:\SqlLog\AdventureWorks2014_Log.ldf',
--      RECOVERY,
--      STATS = 10;
-- GO
-- ALTER DATABASE AdventureWorks2014 SET COMPATIBILITY_LEVEL = 120;
-- GO
-- DBCC CHECKDB (N'AdventureWorks2014') WITH NO_INFOMSGS;
GO
