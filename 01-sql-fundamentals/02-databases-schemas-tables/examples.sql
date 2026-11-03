/* Базы, схемы и таблицы. */
USE AdventureWorks2014;
GO
/* 1. Простой: список пользовательских таблиц и их схем. */
SELECT TOP (20) s.name AS SchemaName, t.name AS TableName
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
ORDER BY s.name, t.name;
GO

/* 2. Продвинутый: описание столбцов конкретной таблицы. */
SELECT c.column_id, c.name, ty.name AS DataType,
       c.max_length, c.precision, c.scale, c.is_nullable
FROM sys.columns AS c
JOIN sys.types AS ty ON ty.user_type_id = c.user_type_id
WHERE c.object_id = OBJECT_ID(N'Production.Product')
ORDER BY c.column_id;
GO

/* 3. Практический: отдельный объект учебной схемы с явным владельцем. */
-- Создание постоянной схемы показано как шаблон и требует прав DDL.
-- CREATE SCHEMA lab AUTHORIZATION dbo;
-- GO
-- CREATE TABLE lab.PriceChange
-- (
--     PriceChangeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
--     ProductID int NOT NULL,
--     NewPrice decimal(19,4) NOT NULL,
--     ChangedAt datetime2(0) NOT NULL DEFAULT SYSDATETIME()
-- );
-- GO

-- Безопасный аналог для занятия — временная таблица текущего сеанса:
CREATE TABLE #PriceChange
(
    PriceChangeID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProductID int NOT NULL,
    NewPrice decimal(19,4) NOT NULL,
    ChangedAt datetime2(0) NOT NULL DEFAULT SYSDATETIME()
);
INSERT #PriceChange (ProductID, NewPrice) VALUES (707, 34.9900);
SELECT * FROM #PriceChange;
DROP TABLE #PriceChange;
GO
