/* Проверка подлинности и авторизация. */
/* 1. Простой: кто подключён и в контексте какого пользователя выполняется код. */
SELECT ORIGINAL_LOGIN() AS OriginalLogin,
       SUSER_SNAME() AS ServerLogin,
       USER_NAME() AS DatabaseUser,
       IS_SRVROLEMEMBER(N'sysadmin') AS IsSysadmin;
GO

/* 2. Продвинутый: участники серверных ролей и их типы. */
SELECT r.name AS ServerRole, p.name AS PrincipalName, p.type_desc
FROM sys.server_role_members AS rm
JOIN sys.server_principals AS r ON r.principal_id = rm.role_principal_id
JOIN sys.server_principals AS p ON p.principal_id = rm.member_principal_id
ORDER BY r.name, p.name;
GO

/* 3. Практический: проверка эффективных прав текущего подключения. */
USE AdventureWorks2014;
GO
SELECT entity_name, subentity_name, permission_name
FROM fn_my_permissions(N'Sales.SalesOrderHeader', N'OBJECT')
ORDER BY permission_name;
GO
/* Не предоставляйте sysadmin приложению ради обхода конкретной ошибки доступа. */
