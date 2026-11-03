/* Маршрут обучения: простой, продвинутый и практический примеры. */

/* 1. Простой: определить экземпляр, на котором выполняются занятия. */
SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('Edition') AS Edition,
       SERVERPROPERTY('ProductLevel') AS ServicePack;
GO

/* 2. Продвинутый: составить карту учебной базы по схемам. */
USE AdventureWorks2014;
GO
SELECT s.name AS SchemaName,
       COUNT(t.object_id) AS TableCount,
       SUM(p.row_count) AS ApproximateRowCount
FROM sys.schemas AS s
LEFT JOIN sys.tables AS t ON t.schema_id = s.schema_id
LEFT JOIN sys.dm_db_partition_stats AS p
  ON p.object_id = t.object_id AND p.index_id IN (0, 1)
WHERE s.name IN (N'Production', N'Sales', N'HumanResources')
GROUP BY s.name
ORDER BY s.name;
GO

/* 3. Практический: проверить готовность обеих баз перед курсом. */
SELECT name AS DatabaseName,
       state_desc AS State,
       compatibility_level AS CompatibilityLevel,
       recovery_model_desc AS RecoveryModel
FROM sys.databases
WHERE name IN (N'AdventureWorks2014', N'AdventureWorksDW2014')
ORDER BY name;

-- Для SQL Server 2014 ожидаются состояние ONLINE и уровень совместимости 120.
IF DB_ID(N'AdventureWorks2014') IS NULL
   OR DB_ID(N'AdventureWorksDW2014') IS NULL
    PRINT N'Сначала восстановите обе учебные базы.';
GO
