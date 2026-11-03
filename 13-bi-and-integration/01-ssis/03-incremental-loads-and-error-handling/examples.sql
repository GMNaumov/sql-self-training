/* Инкрементальная загрузка и обработка ошибок SSIS. */
/* 1. Простой: источник по высокому водяному знаку. */
/*
DECLARE @LastOrderDateKey int = ?;
SELECT SalesOrderNumber, SalesOrderLineNumber, OrderDateKey,
       ProductKey, SalesAmount
FROM AdventureWorksDW2014.dbo.FactInternetSales
WHERE OrderDateKey > @LastOrderDateKey;
*/
GO

/* 2. Продвинутый: повторная загрузка не должна дублировать бизнес-ключ. */
/*
INSERT dbo.SalesFact (OrderNumber, LineNumber, ProductKey, Amount)
SELECT s.OrderNumber, s.LineNumber, s.ProductKey, s.Amount
FROM dbo.SalesStage AS s
WHERE s.BatchID = ?
  AND NOT EXISTS
  (
      SELECT 1 FROM dbo.SalesFact AS f
      WHERE f.OrderNumber = s.OrderNumber AND f.LineNumber = s.LineNumber
  );
*/
GO

/* 3. Практический: ошибочные строки сохраняются с BatchID и причиной. */
/*
INSERT dbo.SalesError (BatchID, SourceRow, ErrorCode, ErrorDescription)
SELECT ?, SourceRow, ErrorCode, ErrorDescription
FROM dbo.SalesStageError;
SELECT BatchID, COUNT(*) AS ErrorCount
FROM dbo.SalesError
WHERE BatchID = ?
GROUP BY BatchID;
*/
GO
/* Watermark обновляют только после успешной публикации всей партии. */
