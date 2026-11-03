/* Разрешения и цепочки владения. */
USE AdventureWorks2014;
GO
/* 1. Простой: явные права на таблицу. */
SELECT dp.name AS Grantee, p.state_desc, p.permission_name,
       s.name AS SchemaName, o.name AS ObjectName
FROM sys.database_permissions AS p
JOIN sys.database_principals AS dp ON dp.principal_id = p.grantee_principal_id
JOIN sys.objects AS o ON o.object_id = p.major_id
JOIN sys.schemas AS s ON s.schema_id = o.schema_id
WHERE p.class = 1 AND o.object_id = OBJECT_ID(N'Sales.SalesOrderHeader');
GO

/* 2. Продвинутый: DENY имеет приоритет над GRANT; показываем все классы прав пользователя. */
SELECT dp.name AS PrincipalName, p.class_desc,
       p.state_desc, p.permission_name
FROM sys.database_permissions AS p
JOIN sys.database_principals AS dp ON dp.principal_id = p.grantee_principal_id
WHERE dp.name NOT IN (N'public', N'guest')
ORDER BY dp.name, p.class_desc, p.permission_name;
GO

/* 3. Практический: EXECUTE на процедуру вместо прямого UPDATE таблицы. */
/*
USE SqlTraining;
GO
GRANT EXECUTE ON dbo.GetCustomerOrders TO LabReportReader;
REVOKE SELECT ON dbo.LabAccount FROM LabReportReader; -- Прямой доступ не нужен операции.
*/
GO
