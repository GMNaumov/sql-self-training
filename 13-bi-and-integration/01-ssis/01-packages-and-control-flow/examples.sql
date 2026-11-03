/* SQL-задачи для SSIS Control Flow; постоянные таблицы создавайте в SqlTraining. */
/* 1. Простой: Execute SQL Task проверяет наличие входной партии. */
/*
DECLARE @BatchID uniqueidentifier = ?; -- Параметр пакета ODBC/OLE DB отмечается '?'.
SELECT BatchID, SourceFileName, LoadedAt
FROM dbo.EtlBatch
WHERE BatchID = @BatchID;
*/
GO

/* 2. Продвинутый: SQL после Data Flow публикует только проверенные строки. */
/*
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT dbo.SalesFact (OrderNumber, ProductKey, Amount)
    SELECT s.OrderNumber, s.ProductKey, s.Amount
    FROM dbo.SalesStage AS s
    WHERE s.BatchID = ? AND NOT EXISTS
    (
        SELECT 1 FROM dbo.SalesFact AS f WHERE f.OrderNumber = s.OrderNumber
    );
    UPDATE dbo.EtlBatch SET Status = N'Loaded' WHERE BatchID = ?;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
*/
GO

/* 3. Практический: Result Set возвращает контрольные показатели пакета. */
SELECT COUNT(*) AS RowsLoaded, SUM(SalesAmount) AS SalesAmount
FROM AdventureWorksDW2014.dbo.FactInternetSales
WHERE OrderDateKey = 20140101;
GO
/* Ветка Success отмечает успех; ветка Failure записывает ошибку и не публикует факт. */
