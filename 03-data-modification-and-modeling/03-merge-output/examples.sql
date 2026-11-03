/* MERGE и OUTPUT на временных данных. */
/* 1. Простой: синхронизация одной строки-источника с целью. */
CREATE TABLE #TargetProduct (ProductID int PRIMARY KEY, Price decimal(19,4) NOT NULL);
INSERT #TargetProduct VALUES (1, 100), (2, 200);
MERGE #TargetProduct AS t
USING (VALUES (1, CAST(110 AS decimal(19,4))), (3, CAST(300 AS decimal(19,4)))) AS s(ProductID, Price)
ON t.ProductID = s.ProductID
WHEN MATCHED THEN UPDATE SET t.Price = s.Price
WHEN NOT MATCHED BY TARGET THEN INSERT (ProductID, Price) VALUES (s.ProductID, s.Price)
OUTPUT $action AS MergeAction, inserted.ProductID, deleted.Price AS OldPrice, inserted.Price AS NewPrice;
SELECT * FROM #TargetProduct;
DROP TABLE #TargetProduct;
GO

/* 2. Продвинутый: журнал изменений создаётся через OUTPUT MERGE. */
CREATE TABLE #StockTarget (ProductID int PRIMARY KEY, Quantity int NOT NULL);
CREATE TABLE #StockSource (ProductID int PRIMARY KEY, Quantity int NOT NULL);
CREATE TABLE #StockChange (ProductID int NOT NULL, OldQuantity int NULL, NewQuantity int NOT NULL);
INSERT #StockTarget VALUES (1, 10), (2, 5);
INSERT #StockSource VALUES (1, 12), (3, 7);
MERGE #StockTarget AS t USING #StockSource AS s ON t.ProductID = s.ProductID
WHEN MATCHED AND t.Quantity <> s.Quantity THEN UPDATE SET t.Quantity = s.Quantity
WHEN NOT MATCHED BY TARGET THEN INSERT (ProductID, Quantity) VALUES (s.ProductID, s.Quantity)
OUTPUT inserted.ProductID, deleted.Quantity, inserted.Quantity
INTO #StockChange (ProductID, OldQuantity, NewQuantity);
SELECT * FROM #StockChange;
DROP TABLE #StockChange;
DROP TABLE #StockSource;
DROP TABLE #StockTarget;
GO

/* 3. Практический: ежедневная синхронизация курса валюты. */
CREATE TABLE #CurrencyRate
(
    CurrencyCode char(3) NOT NULL,
    RateDate date NOT NULL,
    Rate decimal(19,6) NOT NULL,
    PRIMARY KEY (CurrencyCode, RateDate)
);
INSERT #CurrencyRate VALUES ('USD', '20140101', 32.50), ('EUR', '20140101', 44.80);
MERGE #CurrencyRate AS t
USING (VALUES ('USD', CAST('20140101' AS date), CAST(32.70 AS decimal(19,6))),
              ('GBP', CAST('20140101' AS date), CAST(53.10 AS decimal(19,6)))) AS s(CurrencyCode, RateDate, Rate)
ON t.CurrencyCode = s.CurrencyCode AND t.RateDate = s.RateDate
WHEN MATCHED THEN UPDATE SET t.Rate = s.Rate
WHEN NOT MATCHED BY TARGET THEN INSERT (CurrencyCode, RateDate, Rate) VALUES (s.CurrencyCode, s.RateDate, s.Rate)
OUTPUT $action, inserted.CurrencyCode, inserted.RateDate, inserted.Rate;
DROP TABLE #CurrencyRate;
GO
