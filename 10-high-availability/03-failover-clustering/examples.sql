/* Отказоустойчивая кластеризация экземпляра (FCI). */
/* 1. Простой: признак кластеризации и имя сетевого ресурса. */
SELECT SERVERPROPERTY('IsClustered') AS IsClustered,
       SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS ActiveNode,
       @@SERVERNAME AS NetworkName;
GO

/* 2. Продвинутый: узлы и диски, видимые Database Engine. */
SELECT NodeName, status_description FROM sys.dm_os_cluster_nodes;
SELECT DriveName FROM sys.dm_io_cluster_shared_drives; -- На standalone-экземпляре список пуст.
GO

/* 3. Практический: до обслуживания узла проверить активные подключения. */
SELECT s.session_id, s.host_name, s.program_name, s.login_name,
       s.status, c.net_transport
FROM sys.dm_exec_sessions AS s
LEFT JOIN sys.dm_exec_connections AS c ON c.session_id = s.session_id
WHERE s.is_user_process = 1;
GO
/* FCI обеспечивает отказоустойчивость экземпляра, но общий диск остаётся единой копией данных. */
