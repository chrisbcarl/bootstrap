SELECT
    DB_NAME(dbid) as DBName,
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName,
	hostname as HostName
FROM
    sys.sysprocesses
WHERE
    dbid > 0 --and hostname like '%nvdim%'
GROUP BY
    dbid, loginame, hostname
order by NumberOfConnections desc