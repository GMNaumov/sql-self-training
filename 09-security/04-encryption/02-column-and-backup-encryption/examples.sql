/* Шифрование столбцов и резервных копий SQL Server 2014. */
/* 1. Простой: EncryptByPassPhrase подходит для локальной демонстрации, не для хранения пароля в коде. */
SELECT EncryptByPassPhrase(N'Учебная_фраза_не_для_production', N'4111111111111111') AS EncryptedValue;
GO

/* 2. Продвинутый: симметричное шифрование требует заранее созданного ключа SqlTraining. */
/*
USE SqlTraining;
GO
OPEN SYMMETRIC KEY LabDataKey DECRYPTION BY CERTIFICATE LabDataCertificate;
SELECT CONVERT(nvarchar(100), DecryptByKey(EncryptedValue)) AS DecryptedValue
FROM dbo.LabSensitiveData;
CLOSE SYMMETRIC KEY LabDataKey;
*/
GO

/* 3. Практический: encrypted backup требует сертификат и алгоритм. */
/*
BACKUP DATABASE SqlTraining
TO DISK = N'E:\SqlLabBackups\SqlTraining_encrypted.bak'
WITH COMPRESSION, CHECKSUM,
     ENCRYPTION (ALGORITHM = AES_256, SERVER CERTIFICATE = LabBackupCertificate);
*/
GO
/* Без сертификата и его закрытого ключа восстановление на другом экземпляре будет невозможно. */
