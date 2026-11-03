/* IDENTITY и SEQUENCE в SQL Server 2014. */
/* 1. Простой: IDENTITY создаёт значение при INSERT. */
CREATE TABLE #Ticket (TicketID int IDENTITY(1001, 1) PRIMARY KEY, Subject nvarchar(50) NOT NULL);
INSERT #Ticket (Subject) VALUES (N'Первая заявка'), (N'Вторая заявка');
SELECT TicketID, Subject, IDENT_CURRENT('#Ticket') AS LastIdentity FROM #Ticket;
DROP TABLE #Ticket;
GO

/* 2. Продвинутый: одна последовательность нумерует разные операции. */
USE tempdb;
GO
CREATE SEQUENCE dbo.LabOperationNumber AS bigint START WITH 5000 INCREMENT BY 1;
GO
CREATE TABLE #Operation (OperationNumber bigint PRIMARY KEY, OperationType nvarchar(20) NOT NULL);
INSERT #Operation VALUES (NEXT VALUE FOR dbo.LabOperationNumber, N'Платёж'),
                         (NEXT VALUE FOR dbo.LabOperationNumber, N'Возврат');
SELECT * FROM #Operation;
DROP TABLE #Operation;
DROP SEQUENCE dbo.LabOperationNumber;
GO

/* 3. Практический: SET IDENTITY_INSERT для контролируемой миграции ключей. */
CREATE TABLE #LegacyCustomer (CustomerID int IDENTITY(1,1) PRIMARY KEY, CustomerName nvarchar(50) NOT NULL);
SET IDENTITY_INSERT #LegacyCustomer ON;
INSERT #LegacyCustomer (CustomerID, CustomerName) VALUES (100, N'Архивный клиент');
SET IDENTITY_INSERT #LegacyCustomer OFF;
INSERT #LegacyCustomer (CustomerName) VALUES (N'Новый клиент');
SELECT * FROM #LegacyCustomer ORDER BY CustomerID;
DROP TABLE #LegacyCustomer;
GO
