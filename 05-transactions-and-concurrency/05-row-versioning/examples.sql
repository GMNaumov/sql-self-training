/* Версионирование строк и snapshot-изоляция. */
USE AdventureWorks2014;
GO
/* 1. Простой: проверка настроек базы без их изменения. */
SELECT name, is_read_committed_snapshot_on, snapshot_isolation_state_desc
FROM sys.databases
WHERE name = N'AdventureWorks2014';
GO

/* 2. Продвинутый: SNAPSHOT требует ALLOW_SNAPSHOT_ISOLATION ON в выбранной базе. */
/* Настройку меняет администратор отдельно; здесь только проверка перед запуском. */
IF (SELECT snapshot_isolation_state FROM sys.databases WHERE name = DB_NAME()) = 1
BEGIN
    SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
    BEGIN TRANSACTION;
    SELECT ProductID, ListPrice FROM Production.Product WHERE ProductID = 707;
    COMMIT TRANSACTION;
END;
ELSE
    PRINT N'Сначала включите ALLOW_SNAPSHOT_ISOLATION для учебной базы.';
GO

/* 3. Практический: обновление конфликтует, если другая транзакция изменила версию строки. */
CREATE TABLE #Document (DocumentID int PRIMARY KEY, Status varchar(20) NOT NULL, VersionNo int NOT NULL);
INSERT #Document VALUES (1, 'Draft', 1);
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE #Document
    SET Status = 'Approved', VersionNo = VersionNo + 1
    WHERE DocumentID = 1 AND VersionNo = 1;
    IF @@ROWCOUNT = 0 THROW 50120, 'Документ уже изменён другим пользователем.', 1;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
SELECT * FROM #Document;
DROP TABLE #Document;
GO
