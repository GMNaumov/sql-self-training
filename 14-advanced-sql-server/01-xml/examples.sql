/* XML в SQL Server 2014. */
SET QUOTED_IDENTIFIER ON; -- Обязательное значение для методов XML data type.
USE AdventureWorks2014;
GO
/* 1. Простой: FOR XML PATH формирует XML-документ. */
SELECT ProductID AS [@ProductID], Name AS [Name], ListPrice AS [Price]
FROM Production.Product
WHERE ProductID IN (707, 708)
FOR XML PATH('Product'), ROOT('Products');
GO

/* 2. Продвинутый: nodes разбирает XML в строки, value извлекает скаляр. */
DECLARE @xml xml = N'<Payments><Payment Id="1" Amount="125.50"/><Payment Id="2" Amount="40.00"/></Payments>';
SELECT p.n.value(N'@Id', N'int') AS PaymentID,
       p.n.value(N'@Amount', N'decimal(19,4)') AS Amount
FROM @xml.nodes(N'/Payments/Payment') AS p(n);
GO

/* 3. Практический: сформировать заказ с вложенными позициями. */
SELECT h.SalesOrderID AS [@OrderID],
       h.OrderDate AS [@OrderDate],
       (SELECT d.ProductID AS [@ProductID], d.OrderQty AS [@Quantity], d.LineTotal AS [Amount]
        FROM Sales.SalesOrderDetail AS d
        WHERE d.SalesOrderID = h.SalesOrderID
        FOR XML PATH('Line'), TYPE) AS [Lines]
FROM Sales.SalesOrderHeader AS h
WHERE h.SalesOrderID = 43659
FOR XML PATH('Order'), ROOT('Orders');
GO
