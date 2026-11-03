/* Развёртывание и выполнение SSIS 2014 через SSISDB. */
USE SSISDB;
GO
/* 1. Простой: проекты и пакеты каталога. */
SELECT p.name AS ProjectName, pk.name AS PackageName,
       p.folder_name, p.last_deployed_time
FROM catalog.projects AS p
JOIN catalog.packages AS pk ON pk.project_id = p.project_id
ORDER BY p.name, pk.name;
GO

/* 2. Продвинутый: создание execution с параметром выполняется после настройки ссылок среды. */
/*
DECLARE @execution_id bigint;
EXEC catalog.create_execution
     @folder_name = N'Lab', @project_name = N'SalesEtl',
     @package_name = N'LoadSales.dtsx', @execution_id = @execution_id OUTPUT;
EXEC catalog.set_execution_parameter_value
     @execution_id, 30, N'BatchID', N'00000000-0000-0000-0000-000000000000';
EXEC catalog.start_execution @execution_id;
SELECT @execution_id AS ExecutionId;
*/
GO

/* 3. Практический: диагностика выполнения и сообщений ошибок. */
SELECT TOP (20) execution_id, status, start_time, end_time
FROM catalog.executions
ORDER BY execution_id DESC;
GO
/* Доступ к SSISDB и существование Lab/SalesEtl — обязательные предпосылки. */
