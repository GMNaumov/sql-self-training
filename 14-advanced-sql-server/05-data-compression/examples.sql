/* Сжатие данных ROW и PAGE. */
USE AdventureWorks2014;
GO
/* 1. Простой: текущий тип сжатия секций таблицы. */
SELECT p.partition_number, p.rows, p.data_compression_desc
FROM sys.partitions AS p
WHERE p.object_id = OBJECT_ID(N'Sales.SalesOrderDetail')
  AND p.index_id IN (0, 1);
GO

/* 2. Продвинутый: оценка экономии до перестройки индекса. */
EXEC sys.sp_estimate_data_compression_savings
     @schema_name = N'Sales',
     @object_name = N'SalesOrderDetail',
     @index_id = NULL,
     @partition_number = NULL,
     @data_compression = N'PAGE';
GO

/* 3. Практический: перестроение только на учебной копии. */
/*
ALTER INDEX ALL ON Sales.SalesOrderDetail
REBUILD WITH (DATA_COMPRESSION = PAGE, ONLINE = ON);
*/
GO
/* ONLINE доступен не для каждой структуры; измерьте CPU, место и журнал до production. */
