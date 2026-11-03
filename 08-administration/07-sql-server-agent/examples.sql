/* SQL Server Agent: задания, расписания и история. */
USE msdb;
GO
/* 1. Простой: список заданий и их состояние включения. */
SELECT job_id, name, enabled, date_created, date_modified
FROM dbo.sysjobs
ORDER BY name;
GO

/* 2. Продвинутый: последние запуски шагов с длительностью и результатом. */
SELECT TOP (50) j.name AS JobName, h.step_name,
       msdb.dbo.agent_datetime(h.run_date, h.run_time) AS RunAt,
       h.run_status, h.run_duration, h.message
FROM dbo.sysjobhistory AS h
JOIN dbo.sysjobs AS j ON j.job_id = h.job_id
ORDER BY h.instance_id DESC;
GO

/* 3. Практический: запуск учебного задания только по явному имени. */
DECLARE @JobName sysname = N'Lab_Backup_AdventureWorks';
IF EXISTS (SELECT 1 FROM dbo.sysjobs WHERE name = @JobName AND enabled = 1)
    PRINT N'Проверьте шаги и расписание; EXEC dbo.sp_start_job выполняют отдельно.';
ELSE
    PRINT N'Учебное задание не найдено или отключено.';
GO
