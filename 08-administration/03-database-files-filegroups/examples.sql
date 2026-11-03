/* Файлы и файловые группы баз данных. */
/* 1. Простой: размер, рост и расположение файлов текущей базы. */
SELECT name, type_desc, physical_name,
       size * 8.0 / 1024 AS SizeMB,
       growth, is_percent_growth, max_size
FROM sys.database_files
ORDER BY file_id;
GO

/* 2. Продвинутый: свободное место внутри файлов текущей базы. */
SELECT name AS FileName,
       size * 8.0 / 1024 AS SizeMB,
       FILEPROPERTY(name, 'SpaceUsed') * 8.0 / 1024 AS UsedMB,
       (size - FILEPROPERTY(name, 'SpaceUsed')) * 8.0 / 1024 AS FreeMB
FROM sys.database_files
WHERE type_desc = N'ROWS';
GO

/* 3. Практический: шаблон добавления data-файла в отдельную SqlTraining. */
/*
ALTER DATABASE SqlTraining
ADD FILE
(
    NAME = N'SqlTraining_data2',
    FILENAME = N'E:\SqlLabData\SqlTraining_data2.ndf',
    SIZE = 1024MB,
    FILEGROWTH = 256MB
) TO FILEGROUP [PRIMARY];
*/
GO
/* Процентный FILEGROWTH на большом файле может дать чрезмерный шаг роста. */
