/* UPDATE и DELETE во временных таблицах. */
/* 1. Простой: изменение и удаление только по условию. */
CREATE TABLE #Price (ProductID int PRIMARY KEY, ListPrice decimal(19,4) NOT NULL);
INSERT #Price VALUES (1, 100), (2, 200), (3, 0);
UPDATE #Price SET ListPrice = ListPrice * 1.10 WHERE ProductID = 1;
DELETE FROM #Price WHERE ListPrice = 0;
SELECT * FROM #Price ORDER BY ProductID;
DROP TABLE #Price;
GO

/* 2. Продвинутый: UPDATE с соединением и OUTPUT старого/нового значения. */
CREATE TABLE #OrderStatus (OrderID int PRIMARY KEY, Status tinyint NOT NULL);
CREATE TABLE #ApprovedOrder (OrderID int PRIMARY KEY);
INSERT #OrderStatus VALUES (1, 1), (2, 1), (3, 2);
INSERT #ApprovedOrder VALUES (1), (2), (4);
UPDATE o
SET Status = 2
OUTPUT deleted.OrderID, deleted.Status AS OldStatus, inserted.Status AS NewStatus
FROM #OrderStatus AS o
JOIN #ApprovedOrder AS a ON a.OrderID = o.OrderID
WHERE o.Status = 1;
SELECT * FROM #OrderStatus;
DROP TABLE #ApprovedOrder;
DROP TABLE #OrderStatus;
GO

/* 3. Практический: удалить только старые записи архива, сохранив контрольный список. */
CREATE TABLE #AuditEvent
(
    EventID int IDENTITY(1,1) PRIMARY KEY,
    EventDate datetime2(0) NOT NULL,
    IsLegalHold bit NOT NULL
);
INSERT #AuditEvent (EventDate, IsLegalHold)
VALUES ('20200101', 0), ('20240101', 0), ('20200102', 1);
DECLARE @Cutoff datetime2(0) = '20230101';
DELETE FROM #AuditEvent
OUTPUT deleted.EventID, deleted.EventDate
WHERE EventDate < @Cutoff AND IsLegalHold = 0;
SELECT * FROM #AuditEvent;
DROP TABLE #AuditEvent;
GO
