/* Репликация: запросы к distribution выполняются при настроенном distributor. */
/* 1. Простой: публикации текущего экземпляра через distribution. */
/*
USE distribution;
GO
SELECT p.publication, p.publication_type, p.status,
       p.publisher_db, p.description
FROM dbo.MSpublications AS p
ORDER BY p.publication;
*/
GO

/* 2. Продвинутый: подписки и задержки агентов. */
/*
USE distribution;
GO
SELECT s.publisher_db, s.publication, s.subscriber_db,
       s.subscription_type, s.status, s.last_action
FROM dbo.MSsubscriptions AS s
ORDER BY s.publication, s.subscriber_db;
*/
GO

/* 3. Практический: ошибки агентов репликации. */
/*
USE distribution;
GO
SELECT TOP (50) h.agent_id, h.time, h.comments, h.error_id
FROM dbo.MSdistribution_history AS h
WHERE h.error_id <> 0
ORDER BY h.time DESC;
*/
GO
/* Репликация не заменяет backup и обычно не копирует автоматически все объекты и права. */
