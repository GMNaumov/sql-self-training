/* Уровни изоляции: сравнение чтения в отдельных сеансах. */
USE AdventureWorks2014;
GO
/* 1. Простой: READ COMMITTED — стандартный уровень, чтение подтверждённых данных. */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT ProductID, Name, ListPrice
FROM Production.Product
WHERE ProductID = 707;
GO

/* 2. Продвинутый: REPEATABLE READ удерживает shared locks прочитанных строк до конца транзакции. */
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
SELECT ProductID, ListPrice FROM Production.Product WHERE ProductID = 707;
/* Не оставляйте транзакцию открытой: в другом сеансе попробуйте UPDATE той же строки. */
COMMIT TRANSACTION;
GO

/* 3. Практический: SERIALIZABLE защищает диапазон при резервировании последнего места. */
CREATE TABLE #Seat (FlightID int NOT NULL, SeatNo int NOT NULL, PassengerID int NULL,
                    PRIMARY KEY (FlightID, SeatNo));
INSERT #Seat VALUES (100, 1, NULL), (100, 2, NULL);
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
DECLARE @SeatNo int;
SELECT TOP (1) @SeatNo = SeatNo
FROM #Seat WITH (UPDLOCK, HOLDLOCK)
WHERE FlightID = 100 AND PassengerID IS NULL
ORDER BY SeatNo;
UPDATE #Seat SET PassengerID = 42 WHERE FlightID = 100 AND SeatNo = @SeatNo;
COMMIT TRANSACTION;
SELECT * FROM #Seat;
DROP TABLE #Seat;
GO
