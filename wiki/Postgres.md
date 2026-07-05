# PostgreSQL

## Permissions

### Grant All Permissions to Role on Schema

```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO my_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO my_user;
```

[Managing PostgreSQL Users and Roles](https://aws.amazon.com/blogs/database/managing-postgresql-users-and-roles/)

## Database Management

### Terminate Sessions in Database

```sql
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE
  pg_stat_activity.datname = 'TARGET_DB' AND
  pid <> pg_backend_pid();
```

### Show Advisory Locks

```sql
SELECT pid, classid, objid, mode, granted, objsubid 
FROM pg_locks 
WHERE locktype = 'advisory';
```

## psql Commands

### Show Databases

```sql
\l
```

### Show Tables

```sql
\d
```

### Create Database and Users

The `\gexec` command executes the preceding statement.

```bash
#!/bin/bash

set -eu

echo "Creating '$DB_USER@$POSTGRES_HOST/$DB_NAME'"

# POSTGRES_* vars are used by postgres docker container
# PG* vars are used by psql
export PGUSER=$POSTGRES_USER
export PGPASSWORD=$POSTGRES_PASSWORD
export PGHOST=$POSTGRES_HOST

psql -v ON_ERROR_STOP=1 -d postgres <<-EOSQL
SELECT 'CREATE DATABASE "$DB_NAME"'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME')\gexec

SELECT 'CREATE USER "$DB_USER"'
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$DB_USER')\gexec
ALTER USER "$DB_USER" WITH PASSWORD '$DB_PASSWORD';

GRANT ALL PRIVILEGES ON DATABASE "$DB_NAME" TO "$DB_USER";
\c "$DB_NAME"
GRANT ALL ON SCHEMA public TO "$DB_USER";

EOSQL
```
