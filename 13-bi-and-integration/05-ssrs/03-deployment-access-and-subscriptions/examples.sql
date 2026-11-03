/* Развёртывание, доступ и подписки SSRS: каталог ReportServer. */
USE ReportServer;
GO
/* 1. Простой: опубликованные отчёты и пути. */
SELECT ItemID, Path, Name, Description, CreatedByID, ModifiedDate
FROM dbo.Catalog
WHERE Type = 2
ORDER BY Path;
GO

/* 2. Продвинутый: активные подписки и расписания. */
SELECT c.Path AS ReportPath, s.Description, s.LastStatus,
       s.LastRunTime, s.EventType
FROM dbo.Subscriptions AS s
JOIN dbo.Catalog AS c ON c.ItemID = s.Report_OID
ORDER BY c.Path, s.Description;
GO

/* 3. Практический: история выполнения отчёта для разбора ошибки подписки. */
SELECT TOP (50) c.Path, e.TimeStart, e.TimeEnd,
       e.Status, e.ReportAction, e.Source
FROM dbo.ExecutionLogStorage AS e
JOIN dbo.Catalog AS c ON c.ItemID = e.ReportID
ORDER BY e.TimeStart DESC;
GO
/* Не редактируйте таблицы ReportServer напрямую: используйте портал, RS API и настройки ролей. */
