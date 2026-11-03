/* Архитектура экземпляра и службы. */
/* 1. Простой: версия, редакция и имя экземпляра. */
SELECT @@SERVERNAME AS ServerName,
       SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('Edition') AS Edition,
       SERVERPROPERTY('ProductLevel') AS ProductLevel;
GO

/* 2. Продвинутый: состояние служб Database Engine и связанных компонентов. */
SELECT servicename, startup_type_desc, status_desc, service_account
FROM sys.dm_server_services
ORDER BY servicename;
GO

/* 3. Практический: карта баз и файлов для паспорта сервера. */
SELECT d.name AS DatabaseName, d.state_desc, d.recovery_model_desc,
       mf.type_desc, mf.physical_name,
       mf.size * 8.0 / 1024 AS SizeMB
FROM sys.databases AS d
JOIN sys.master_files AS mf ON mf.database_id = d.database_id
ORDER BY d.name, mf.file_id;
GO
