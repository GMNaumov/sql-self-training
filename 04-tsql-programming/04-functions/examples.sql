/* Пользовательские функции. Постоянные модули создавайте только в SqlTraining. */
USE SqlTraining;
GO
/* 1. Простой: скалярная функция округляет денежное значение. */
IF OBJECT_ID(N'dbo.RoundMoney', N'FN') IS NOT NULL DROP FUNCTION dbo.RoundMoney;
GO
CREATE FUNCTION dbo.RoundMoney(@Amount decimal(19,4))
RETURNS decimal(19,2)
AS
BEGIN
    RETURN ROUND(@Amount, 2);
END;
GO
SELECT dbo.RoundMoney(123.456) AS RoundedAmount;
GO

/* 2. Продвинутый: inline TVF сохраняет декларативность и встраивается оптимизатором. */
IF OBJECT_ID(N'dbo.GetSalesByProduct', N'IF') IS NOT NULL DROP FUNCTION dbo.GetSalesByProduct;
GO
CREATE FUNCTION dbo.GetSalesByProduct(@ProductID int)
RETURNS table
AS
RETURN
(
    SELECT d.SalesOrderID, d.OrderQty, d.UnitPrice, d.LineTotal
    FROM AdventureWorks2014.Sales.SalesOrderDetail AS d
    WHERE d.ProductID = @ProductID
);
GO
SELECT TOP (10) * FROM dbo.GetSalesByProduct(707) ORDER BY SalesOrderID;
GO

/* 3. Практический: многооператорная TVF для банковской витрины по счёту. */
IF OBJECT_ID(N'dbo.GetAccountTurnover', N'TF') IS NOT NULL DROP FUNCTION dbo.GetAccountTurnover;
GO
CREATE FUNCTION dbo.GetAccountTurnover(@AccountID int)
RETURNS @Result table
(
    AccountID int NOT NULL,
    DebitAmount decimal(19,4) NOT NULL,
    CreditAmount decimal(19,4) NOT NULL
)
AS
BEGIN
    /* Здесь учебные значения; в реальной базе источником была бы таблица проводок. */
    INSERT @Result VALUES (@AccountID, 1200.00, 950.00);
    RETURN;
END;
GO
SELECT * FROM dbo.GetAccountTurnover(101);
GO
