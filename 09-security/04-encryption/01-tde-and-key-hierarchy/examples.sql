/* TDE и иерархия ключей: команды подготовки требуют резервных копий ключей. */
/* 1. Простой: состояние TDE по базам. */
SELECT d.name AS DatabaseName, e.encryption_state,
       e.key_algorithm, e.key_length, e.percent_complete
FROM sys.dm_database_encryption_keys AS e
RIGHT JOIN sys.databases AS d ON d.database_id = e.database_id
ORDER BY d.name;
GO

/* 2. Продвинутый: сертификаты master и сроки действия. */
USE master;
GO
SELECT name, subject, expiry_date, pvt_key_encryption_type_desc
FROM sys.certificates
ORDER BY expiry_date;
GO

/* 3. Практический: шаблон включения TDE только для SqlTraining. */
/*
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Замените_на_секрет_из_хранилища';
CREATE CERTIFICATE LabTdeCertificate WITH SUBJECT = N'Lab TDE';
BACKUP CERTIFICATE LabTdeCertificate TO FILE = N'E:\SqlLabKeys\LabTdeCertificate.cer'
WITH PRIVATE KEY
(
    FILE = N'E:\SqlLabKeys\LabTdeCertificate_private.key',
    ENCRYPTION BY PASSWORD = 'Замените_на_другой_секрет'
);
USE SqlTraining;
GO
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE LabTdeCertificate;
ALTER DATABASE SqlTraining SET ENCRYPTION ON;
*/
GO
