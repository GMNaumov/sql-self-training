/* Операции над множествами. */
USE AdventureWorks2014;
GO
/* 1. Простой: UNION удаляет дубликаты, UNION ALL сохраняет все строки. */
SELECT Color FROM Production.Product WHERE ProductID BETWEEN 707 AND 710
UNION
SELECT Color FROM Production.Product WHERE ProductID BETWEEN 709 AND 712
ORDER BY Color;
GO

/* 2. Продвинутый: EXCEPT и INTERSECT сравнивают наборы товаров. */
-- Есть в каталоге, но нет среди проданных:
SELECT p.ProductID FROM Production.Product AS p
EXCEPT
SELECT d.ProductID FROM Sales.SalesOrderDetail AS d;

-- Есть и в каталоге, и среди проданных:
SELECT p.ProductID FROM Production.Product AS p
INTERSECT
SELECT d.ProductID FROM Sales.SalesOrderDetail AS d;
GO

/* 3. Практический: сверка двух выгрузок остатков склада. */
CREATE TABLE #OldStock (ProductID int NOT NULL, Quantity int NOT NULL);
CREATE TABLE #NewStock (ProductID int NOT NULL, Quantity int NOT NULL);
INSERT #OldStock VALUES (1, 10), (2, 5), (3, 8);
INSERT #NewStock VALUES (1, 10), (2, 7), (4, 3);

SELECT N'Только в новой выгрузке' AS Difference, ProductID, Quantity
FROM (SELECT ProductID, Quantity FROM #NewStock
      EXCEPT SELECT ProductID, Quantity FROM #OldStock) AS x
UNION ALL
SELECT N'Только в старой выгрузке', ProductID, Quantity
FROM (SELECT ProductID, Quantity FROM #OldStock
      EXCEPT SELECT ProductID, Quantity FROM #NewStock) AS y
ORDER BY ProductID, Difference;
DROP TABLE #NewStock;
DROP TABLE #OldStock;
GO
