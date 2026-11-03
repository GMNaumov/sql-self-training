/* Секционирование: сначала функция и схема, затем таблица. */
USE AdventureWorks2014;
GO
/* 1. Простой: найти существующие секционированные объекты. */
SELECT OBJECT_NAME(p.object_id) AS TableName, p.partition_number,
       p.rows, pf.name AS PartitionFunction
FROM sys.partitions AS p
JOIN sys.indexes AS i ON i.object_id = p.object_id AND i.index_id = p.index_id
LEFT JOIN sys.partition_schemes AS ps ON ps.data_space_id = i.data_space_id
LEFT JOIN sys.partition_functions AS pf ON pf.function_id = ps.function_id
WHERE i.index_id IN (0, 1) AND pf.name IS NOT NULL;
GO

/* 2. Продвинутый: $PARTITION показывает номер секции для граничной даты. */
SELECT TOP (20) h.SalesOrderID, h.OrderDate
FROM Sales.SalesOrderHeader AS h
WHERE h.OrderDate >= '20130101' AND h.OrderDate < '20140101'
ORDER BY h.OrderDate, h.SalesOrderID;
GO
/* Полный SWITCH требует одинаковых структур, индексов, ограничений и выровненных схем. */

/* 3. Практический: шаблон ежемесячного архивирования для отдельной SqlTraining. */
/*
CREATE PARTITION FUNCTION pf_SalesMonth (date)
AS RANGE RIGHT FOR VALUES ('20240101', '20240201', '20240301');
CREATE PARTITION SCHEME ps_SalesMonth AS PARTITION pf_SalesMonth ALL TO ([PRIMARY]);
CREATE TABLE dbo.SalesArchive
(
    SaleID bigint NOT NULL,
    SaleDate date NOT NULL,
    Amount money NOT NULL,
    CONSTRAINT PK_SalesArchive PRIMARY KEY NONCLUSTERED (SaleID, SaleDate)
) ON ps_SalesMonth(SaleDate);
*/
GO
