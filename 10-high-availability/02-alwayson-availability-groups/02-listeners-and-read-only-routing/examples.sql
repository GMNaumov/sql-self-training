/* Прослушиватели AG и read-only routing. */
/* 1. Простой: DNS-имена, порты и IP прослушивателей. */
SELECT l.dns_name, l.port, l.ip_configuration_string_from_cluster
FROM sys.availability_group_listeners AS l;
GO

/* 2. Продвинутый: URL маршрутизации вторичных реплик. */
SELECT ar.replica_server_name, ar.secondary_role_allow_connections_desc,
       ar.read_only_routing_url,
       ror.routing_priority, target.replica_server_name AS TargetReplica
FROM sys.availability_replicas AS ar
LEFT JOIN sys.availability_read_only_routing_lists AS ror ON ror.replica_id = ar.replica_id
LEFT JOIN sys.availability_replicas AS target ON target.replica_id = ror.read_only_replica_id
ORDER BY ar.replica_server_name, ror.routing_priority;
GO

/* 3. Практический: проверка, куда фактически попал read-only клиент. */
SELECT @@SERVERNAME AS ConnectedServer,
       DATABASEPROPERTYEX(DB_NAME(), 'Updateability') AS DatabaseUpdateability;
GO
/* Строка подключения должна содержать ApplicationIntent=ReadOnly и имя listener, не узла. */
