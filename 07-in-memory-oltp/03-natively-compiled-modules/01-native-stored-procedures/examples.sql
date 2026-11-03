/* Нативно скомпилированные процедуры 2014: только подготовленная SqlTraining. */
/* 1. Простой: список существующих native-модулей. */
SELECT s.name AS SchemaName, OBJECT_NAME(m.object_id) AS ModuleName
FROM sys.all_sql_modules AS m
JOIN sys.objects AS o ON o.object_id = m.object_id
JOIN sys.schemas AS s ON s.schema_id = o.schema_id
WHERE m.uses_native_compilation = 1;
GO

/* 2. Продвинутый: native-процедура требует SCHEMABINDING и ATOMIC блок. */
/*
USE SqlTraining;
GO
CREATE PROCEDURE dbo.LabGetOrderState @OrderID int
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'English')
    SELECT OrderID, Status, UpdatedAt
    FROM dbo.LabOrderState
    WHERE OrderID = @OrderID;
END;
*/
GO

/* 3. Практический: вызов после создания dbo.LabOrderState и процедуры. */
/* EXEC dbo.LabGetOrderState @OrderID = 1; */
GO
