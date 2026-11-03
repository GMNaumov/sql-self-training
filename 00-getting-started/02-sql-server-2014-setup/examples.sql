/* Установка и настройка: команды чтения безопасны, изменения только шаблоны. */

/* 1. Простой: проверить версию и каталоги экземпляра по умолчанию. */
SELECT SERVERPROPERTY('MachineName') AS MachineName,
       SERVERPROPERTY('InstanceName') AS InstanceName,
       SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('InstanceDefaultDataPath') AS DefaultDataPath,
       SERVERPROPERTY('InstanceDefaultLogPath') AS DefaultLogPath;
GO

/* 2. Продвинутый: сопоставить важные параметры без их изменения. */
SELECT name, value, value_in_use, description
FROM sys.configurations
WHERE name IN (N'max server memory (MB)', N'max degree of parallelism',
               N'cost threshold for parallelism', N'optimize for ad hoc workloads')
ORDER BY name;

SELECT database_id, file_id, type_desc, physical_name, size * 8 / 1024 AS SizeMB
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb')
ORDER BY file_id;
GO

/* 3. Практический: шаблон первоначальной настройки нового стенда. */
-- Сначала измерьте память ОС и других служб. Не копируйте значения на боевой сервер.
-- EXEC sys.sp_configure N'show advanced options', 1;
-- RECONFIGURE;
-- EXEC sys.sp_configure N'max server memory (MB)', 8192;
-- EXEC sys.sp_configure N'optimize for ad hoc workloads', 1;
-- RECONFIGURE;

-- Проверка после согласованного изменения:
SELECT name, value, value_in_use
FROM sys.configurations
WHERE name IN (N'max server memory (MB)', N'optimize for ad hoc workloads');
GO
