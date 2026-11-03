/* ATOMIC-блоки и ограничения native T-SQL SQL Server 2014. */
/* 1. Простой: атомарный блок подтверждается целиком или откатывается целиком. */
/*
USE SqlTraining;
GO
CREATE PROCEDURE dbo.LabSetOrderStatus
    @OrderID int,
    @Status tinyint
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = N'English')
    UPDATE dbo.LabOrderState
    SET Status = @Status, UpdatedAt = SYSDATETIME()
    WHERE OrderID = @OrderID;
END;
*/
GO

/* 2. Продвинутый: конфликт записи требует повторной попытки всей операции. */
DECLARE @Attempt int = 1;
WHILE @Attempt <= 3
BEGIN
    BEGIN TRY
        /* EXEC dbo.LabSetOrderStatus @OrderID = 1, @Status = 2; */
        BREAK;
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() NOT IN (41302, 41305, 41325, 41301) THROW;
        SET @Attempt += 1;
    END CATCH;
END;
GO

/* 3. Практический: перед миграцией проверьте неподдерживаемые конструкции в модуле. */
SELECT m.object_id, OBJECT_NAME(m.object_id) AS ModuleName, m.uses_native_compilation
FROM sys.all_sql_modules AS m
WHERE m.uses_native_compilation = 1;
GO
/* В 2014 не переносите механически TRY/CATCH, произвольный T-SQL и ALTER native-модуля. */
