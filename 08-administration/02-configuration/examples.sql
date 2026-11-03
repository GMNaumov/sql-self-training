/* Конфигурация SQL Server 2014: сначала чтение, изменение — отдельно. */
/* 1. Простой: значения важных параметров экземпляра. */
SELECT name, value, value_in_use, is_dynamic, description
FROM sys.configurations
WHERE name IN (N'max server memory (MB)', N'min server memory (MB)',
               N'max degree of parallelism', N'cost threshold for parallelism')
ORDER BY name;
GO

/* 2. Продвинутый: сравнить настроенное и действующее значение. */
SELECT name, value AS ConfiguredValue, value_in_use AS RunningValue
FROM sys.configurations
WHERE is_dynamic = 0 AND value <> value_in_use;
GO

/* 3. Практический: шаблон изменения max server memory после расчёта памяти ОС. */
/*
EXEC sys.sp_configure N'show advanced options', 1;
RECONFIGURE;
EXEC sys.sp_configure N'max server memory (MB)', 12288; -- Учебное значение, не рекомендация.
RECONFIGURE;
*/
GO
/* Проверьте memory grants и показатели ОС; не копируйте значение на другой сервер. */
