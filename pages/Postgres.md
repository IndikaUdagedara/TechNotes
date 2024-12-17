- Grant all permissions to role on schema  
  
    ```
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO my_user;  
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO my_user;
    ```
    [https://aws.amazon.com/blogs/database/managing-postgresql-users-and-roles/](https://aws.amazon.com/blogs/database/managing-postgresql-users-and-roles/)
- Terminate sessions in `TARGET_DB`
  ```
  SELECT pg_terminate_backend(pg_stat_activity.pid)
  FROM pg_stat_activity
  WHERE
  pg_stat_activity.datname ='TARGET_DB' AND
  pid <> pg_backend_pid();
  ```
- show advisory locks
  ```
  SELECT pid, classid, objid, mode, granted, objsubid FROM pg_locks WHERE locktype = 'advisory'
  ```
- ## psql
- show databases `\l`
- show tables `\d`
- create db and users
  `\gexec` executes the preceding statement
  
  ```
  #!/bin/bash
  
  set -eu
  
  echo "Creating '$DB_USER@$POSTGRES_HOST/$DB_NAME"
  
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
-