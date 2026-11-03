/* Логины, пользователи и роли. Изменяющие команды — шаблоны для лаборатории. */
/* 1. Простой: сопоставление логинов и пользователей текущей базы. */
SELECT dp.name AS DatabaseUser, dp.type_desc,
       sp.name AS ServerLogin
FROM sys.database_principals AS dp
LEFT JOIN sys.server_principals AS sp ON sp.sid = dp.sid
WHERE dp.type IN ('S', 'U') AND dp.name <> N'dbo'
ORDER BY dp.name;
GO

/* 2. Продвинутый: участники пользовательских ролей базы. */
SELECT r.name AS DatabaseRole, m.name AS MemberName, m.type_desc
FROM sys.database_role_members AS rm
JOIN sys.database_principals AS r ON r.principal_id = rm.role_principal_id
JOIN sys.database_principals AS m ON m.principal_id = rm.member_principal_id
ORDER BY r.name, m.name;
GO

/* 3. Практический: минимальная роль отчётности без db_owner. */
/*
USE SqlTraining;
GO
CREATE ROLE LabReportReader AUTHORIZATION dbo;
GRANT SELECT ON SCHEMA::dbo TO LabReportReader;
-- Пользователь создаётся от существующего учебного логина, пароль в скрипте не хранится.
-- CREATE USER LabReportUser FOR LOGIN LabReportLogin;
-- ALTER ROLE LabReportReader ADD MEMBER LabReportUser;
*/
GO
