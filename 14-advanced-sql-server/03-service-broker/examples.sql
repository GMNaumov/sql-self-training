/* Service Broker: постоянные объекты создаются только в SqlTraining. */
/* 1. Простой: включён ли Service Broker в текущей базе. */
SELECT DB_NAME() AS DatabaseName, is_broker_enabled
FROM sys.databases
WHERE database_id = DB_ID();
GO

/* 2. Продвинутый: очереди, службы и маршруты текущей базы. */
SELECT name AS QueueName, is_receive_enabled, is_enqueue_enabled
FROM sys.service_queues;
SELECT name AS ServiceName FROM sys.services;
SELECT name AS RouteName, remote_service_name, broker_instance
FROM sys.routes;
GO

/* 3. Практический: отправка сообщения по уже созданному контракту LabOrderContract. */
/*
USE SqlTraining;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE @dialog uniqueidentifier;
    BEGIN DIALOG CONVERSATION @dialog
        FROM SERVICE LabOrderService
        TO SERVICE N'LabOrderTarget', N'CURRENT DATABASE'
        ON CONTRACT LabOrderContract
        WITH ENCRYPTION = OFF;
    SEND ON CONVERSATION @dialog MESSAGE TYPE LabOrderMessage
        (N'<Order OrderID="1001"/>');
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
*/
GO
/* Тип сообщения, контракт, очереди и службы должны быть созданы заранее. */
