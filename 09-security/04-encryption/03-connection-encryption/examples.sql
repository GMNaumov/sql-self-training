/* Шифрование подключений и TLS. */
/* 1. Простой: зашифрованы ли текущие подключения. */
SELECT s.session_id, s.login_name, c.net_transport, c.protocol_type,
       c.encrypt_option, c.auth_scheme
FROM sys.dm_exec_connections AS c
JOIN sys.dm_exec_sessions AS s ON s.session_id = c.session_id
WHERE s.is_user_process = 1
ORDER BY s.session_id;
GO

/* 2. Продвинутый: сертификаты экземпляра через конфигурационные DMV недоступны — проверяем соединение. */
SELECT DISTINCT net_transport, encrypt_option, auth_scheme
FROM sys.dm_exec_connections
ORDER BY net_transport, encrypt_option;
GO

/* 3. Практический: проверка требований банковского приложения. */
SELECT c.session_id, s.host_name, s.program_name,
       c.client_net_address, c.encrypt_option
FROM sys.dm_exec_connections AS c
JOIN sys.dm_exec_sessions AS s ON s.session_id = c.session_id
WHERE s.is_user_process = 1 AND c.encrypt_option = N'FALSE';
GO
/* Принудительное шифрование и сертификат настраивают в Configuration Manager, затем проверяют TLS. */
