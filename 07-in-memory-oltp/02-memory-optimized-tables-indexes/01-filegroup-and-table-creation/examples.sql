/* Подготовка In-Memory OLTP: требуется отдельная SqlTraining и новый каталог. */
/* 1. Простой: проверка существующей конфигурации без изменения базы. */
SELECT DB_NAME() AS DatabaseName, compatibility_level
FROM sys.databases
WHERE name = N'SqlTraining';
SELECT name, type_desc FROM sys.filegroups WHERE type = N'FX';
GO

/* 2. Продвинутый: команды подготовки адаптирует администратор; автоматически не выполнять. */
/*
ALTER DATABASE SqlTraining SET COMPATIBILITY_LEVEL = 120;
ALTER DATABASE SqlTraining ADD FILEGROUP LabMemory CONTAINS MEMORY_OPTIMIZED_DATA;
ALTER DATABASE SqlTraining ADD FILE
(
    NAME = N'LabMemoryContainer',
    FILENAME = N'E:\SqlLabData\SqlTrainingMemory'
) TO FILEGROUP LabMemory;
*/
GO

/* 3. Практический: состояние заказа в памяти; выполнять после подготовки SqlTraining. */
/*
USE SqlTraining;
GO
CREATE TABLE dbo.LabOrderState
(
    OrderID int NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH (BUCKET_COUNT = 1024),
    Status tinyint NOT NULL,
    UpdatedAt datetime2 NOT NULL,
    INDEX IX_LabOrderState_Status NONCLUSTERED (Status)
)
WITH (MEMORY_OPTIMIZED = ON, DURABILITY = SCHEMA_AND_DATA);
INSERT dbo.LabOrderState VALUES (1, 0, SYSDATETIME());
SELECT * FROM dbo.LabOrderState;
*/
GO
