/* Extended Events и журнал ошибок. */
/* 1. Простой: активные события сессий XE. */
SELECT s.name AS SessionName, s.create_time, t.target_name
FROM sys.dm_xe_sessions AS s
LEFT JOIN sys.dm_xe_session_targets AS t ON t.event_session_address = s.address
ORDER BY s.name, t.target_name;
GO

/* 2. Продвинутый: последние строки текущего errorlog. */
EXEC sys.xp_readerrorlog 0, 1;
GO

/* 3. Практический: получить ring buffer system_health для разбора инцидента. */
SELECT s.name AS SessionName, CAST(t.target_data AS xml) AS TargetData
FROM sys.dm_xe_sessions AS s
JOIN sys.dm_xe_session_targets AS t ON t.event_session_address = s.address
WHERE s.name = N'system_health' AND t.target_name = N'ring_buffer';
GO
/* Для постоянной XE-сессии задайте файл, ротацию, события и допустимую нагрузку заранее. */
