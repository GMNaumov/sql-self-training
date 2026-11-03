/* Динамический SQL: значения передаются параметрами, а не склейкой. */
USE AdventureWorks2014;
GO
/* 1. Простой: параметризованный фильтр через sp_executesql. */
DECLARE @sql nvarchar(max) =
    N'SELECT SalesOrderID, OrderDate, SubTotal
      FROM Sales.SalesOrderHeader
      WHERE CustomerID = @CustomerID AND OrderDate >= @FromDate
      ORDER BY SalesOrderID;';
EXEC sys.sp_executesql @sql, N'@CustomerID int, @FromDate date',
     @CustomerID = 11000, @FromDate = '20130101';
GO

/* 2. Продвинутый: имя столбца нельзя передать обычным параметром — используем белый список. */
DECLARE @SortColumn sysname = N'OrderDate';
DECLARE @OrderExpression nvarchar(100) =
    CASE @SortColumn
        WHEN N'OrderDate' THEN N'OrderDate'
        WHEN N'SubTotal' THEN N'SubTotal'
        ELSE N'SalesOrderID'
    END;
DECLARE @sql nvarchar(max) =
    N'SELECT TOP (20) SalesOrderID, OrderDate, SubTotal
      FROM Sales.SalesOrderHeader
      WHERE CustomerID = @CustomerID
      ORDER BY ' + @OrderExpression + N' DESC, SalesOrderID;';
EXEC sys.sp_executesql @sql, N'@CustomerID int', @CustomerID = 11000;
GO

/* 3. Практический: поисковый отчёт с необязательными параметрами. */
DECLARE @CustomerID int = NULL, @Status tinyint = 5;
DECLARE @sql nvarchar(max) =
    N'SELECT SalesOrderID, CustomerID, OrderDate, Status, SubTotal
      FROM Sales.SalesOrderHeader
      WHERE (@CustomerID IS NULL OR CustomerID = @CustomerID)
        AND (@Status IS NULL OR Status = @Status)
      ORDER BY SalesOrderID;';
EXEC sys.sp_executesql @sql, N'@CustomerID int, @Status tinyint',
     @CustomerID = @CustomerID, @Status = @Status;
GO
