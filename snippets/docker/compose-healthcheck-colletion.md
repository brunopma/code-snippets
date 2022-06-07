# Docker-compose healthcheck colletion

Collection of simple healthchecks for various services
https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck

Remember that:
| Parameter | Description |
| ----------- | ----------- |
| test | Command to run to check health |
| interval | Time between running the check |
| retries | Consecutive failures needed to report unhealthy. It accept integer value |
| timeout | Maximum time to allow one check to run |
| start_period | Start period for the container to initialize before starting health-retries countdown |



## curl
The simplest curl healthcheck is to use a specific endpoint like /ping or /health, or as a last resource, try to curl the favicon or other static small resource
```
healthcheck:
  test: curl -fsS http://localhost:{PORT}/{ENDPOINT}
  interval: 30s
  timeout: 3s
  retries: 3
  start_period: 30s
```

## nginx
Add this location to the nginx.conf file, inside server:
```
server {
  location /health {
    access_log off;
    add_header 'Content-Type' 'application/json';
    return 200 '{"status":"UP"}';
  }
}
```
and query this endpoint like this:
```
healthcheck:
  test: curl -fsSL http://localhost:{PORT}/{ENDPOINT}
  interval: 30s
  timeout: 3s
  retries: 3
```

## wget
Much like curl, with wget we try to query for the simplest endpoint, normally a specific health or some small static endpoint. I'm using `--spider` to only check if the connection is available and responding, not downloading anything
```
healthcheck:
  test: wget --spider -q http://localhost:{PORT}/{ENDPOINT}
  interval: 30s
  timeout: 3s
  retries: 3
  start_period: 30s
```

## MySQL / MariaDB
The test here is a bit different, and we have to use the mysqladmin cli to perform a simple query to the database
```
healthcheck:
  test: ['CMD', 'mysqladmin', 'ping', '-u', 'root', '-p${MYSQL_ROOT_PASSWORD}'] # using root here, but can be any other user. Remember to change the env var to the user password
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 5s
```

## Postgres
Same as mysql, we have to use a specific postgres cli, already bundled in most pg images
```
healthcheck:
  test: ["CMD-SHELL", "pg_isready"]
  interval: 10s
  timeout: 5s
  retries: 5
```

## Redis
This example is when redis connection is not being made with TCP, but mounting the unix socket instead.
To use the default TCP connection, just delete the `-s {SOCKET}` part
```
healthcheck:
      test: ["CMD", "redis-cli", "-s", "/var/run/redis/redis.sock", --raw, "incr", "ping"]
      interval: 30s
      timeout: 3s
      retries: 3
```