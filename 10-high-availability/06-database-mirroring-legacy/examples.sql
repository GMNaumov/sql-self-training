/* Зеркальное отображение базы данных: устаревшая технология 2014. */
/* 1. Простой: роль и состояние mirroring для всех баз. */
SELECT d.name AS DatabaseName, m.mirroring_role_desc,
       m.mirroring_state_desc, m.mirroring_safety_level_desc,
       m.mirroring_witness_state_desc
FROM sys.database_mirroring AS m
JOIN sys.databases AS d ON d.database_id = m.database_id
WHERE m.mirroring_guid IS NOT NULL;
GO

/* 2. Продвинутый: очереди и задержка зеркальной копии. */
SELECT DB_NAME(database_id) AS DatabaseName,
       mirroring_role_desc, mirroring_state_desc,
       mirroring_redo_queue_type, mirroring_connection_timeout
FROM sys.database_mirroring
WHERE mirroring_guid IS NOT NULL;
GO

/* 3. Практический: проверка endpoint перед миграцией legacy-конфигурации. */
SELECT t.name, t.type_desc, t.state_desc, t.port,
       e.encryption_algorithm_desc
FROM sys.tcp_endpoints AS t
JOIN sys.database_mirroring_endpoints AS e ON e.endpoint_id = t.endpoint_id
WHERE t.type_desc = N'DATABASE_MIRRORING';
GO
/* Для нового проекта предпочтительнее AG; mirroring здесь рассматривается для поддержки legacy. */
