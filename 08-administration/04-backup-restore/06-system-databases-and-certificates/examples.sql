/* Системные базы, сертификаты и ключи восстановления. */
/* 1. Простой: история backup системных баз. */
SELECT d.name AS DatabaseName,
       MAX(CASE WHEN b.type = 'D' THEN b.backup_finish_date END) AS LastFullBackup
FROM sys.databases AS d
LEFT JOIN msdb.dbo.backupset AS b ON b.database_name = d.name AND b.type = 'D'
WHERE d.name IN (N'master', N'model', N'msdb')
GROUP BY d.name
ORDER BY d.name;
GO

/* 2. Продвинутый: перечень сертификатов master без вывода закрытых ключей. */
USE master;
GO
SELECT name, cert_serial_number, expiry_date, pvt_key_encryption_type_desc
FROM sys.certificates
ORDER BY name;
GO

/* 3. Практический: backup сертификата в учебный защищённый каталог. */
/*
BACKUP CERTIFICATE LabBackupCertificate
TO FILE = N'E:\SqlLabKeys\LabBackupCertificate.cer'
WITH PRIVATE KEY
(
    FILE = N'E:\SqlLabKeys\LabBackupCertificate_private.key',
    ENCRYPTION BY PASSWORD = 'Замените_на_секрет_из_хранилища'
);
*/
GO
/* Файлы ключей хранят отдельно от backup; реальные секреты не записывают в репозиторий. */
