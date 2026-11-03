/* Режимы доступности и отработка отказа AG. */
/* 1. Простой: роль и здоровье локальных реплик. */
SELECT ar.replica_server_name, ars.role_desc,
       ars.operational_state_desc, ars.connected_state_desc,
       ars.synchronization_health_desc
FROM sys.availability_replicas AS ar
JOIN sys.dm_hadr_availability_replica_states AS ars ON ars.replica_id = ar.replica_id;
GO

/* 2. Продвинутый: очереди отправки и восстановления по базам. */
SELECT ar.replica_server_name, DB_NAME(d.database_id) AS DatabaseName,
       d.synchronization_state_desc, d.log_send_queue_size,
       d.redo_queue_size, d.last_commit_time
FROM sys.dm_hadr_database_replica_states AS d
JOIN sys.availability_replicas AS ar ON ar.replica_id = d.replica_id
ORDER BY ar.replica_server_name, DatabaseName;
GO

/* 3. Практический: ручной failover выполняют только после проверки SYNCHRONIZED. */
/*
-- На новой предполагаемой primary-реплике, для synchronous AG:
ALTER AVAILABILITY GROUP LabAG FAILOVER;
*/
GO
/* Автоматический failover требует synchronous-commit, automatic mode и здоровой кворумной инфраструктуры. */
