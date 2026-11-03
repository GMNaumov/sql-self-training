/* Аудит SQL Server 2014. */
/* 1. Простой: серверные аудиты и их состояние. */
SELECT name, audit_guid, on_failure_desc, is_state_enabled,
       queue_delay, predicate
FROM sys.server_audits
ORDER BY name;
GO

/* 2. Продвинутый: спецификации аудита базы и действия. */
USE AdventureWorks2014;
GO
SELECT s.name AS SpecificationName, s.is_state_enabled,
       a.audit_action_id, a.audit_action_name,
       dp.name AS PrincipalName
FROM sys.database_audit_specifications AS s
LEFT JOIN sys.database_audit_specification_details AS a
  ON a.database_specification_id = s.database_specification_id
LEFT JOIN sys.database_principals AS dp ON dp.principal_id = a.audited_principal_id;
GO

/* 3. Практический: чтение файлового аудита, если он уже настроен. */
/*
SELECT event_time, action_id, succeeded, server_principal_name,
       database_name, schema_name, object_name, statement
FROM sys.fn_get_audit_file(N'E:\SqlLabAudit\LabAudit_*.sqlaudit', NULL, NULL)
WHERE database_name = N'SqlTraining'
ORDER BY event_time DESC;
*/
GO
/* Включение аудита требует отдельного CREATE SERVER AUDIT и прав администратора. */
