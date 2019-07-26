# BACULA DIRECTOR

Bacula Director container.

# Environments

No variable are required to run the container. All have a default value.

### BACULA_DBHOST

Bacula catalog host database (default **bacula**)

### BACULA_DBNAME

Bacula catalog database name (default **baculadb**)

### BACULA_DBUSER

Bacula catalog database username (default **bacula**)

### BACULA_DBPASSWORD

Bacula catalog database user password (default **bacula**)

### BACULA_FDPASSWORD

Bacula File Daemon password (default **password**)

### BACULA_SDPASSWORD

Bacula Storage Deamon password (default **password**)

### BACULA_CONSOLEPASSWORD

Bacula console password (default **password**)

### BACULA_DIRNAME

Bacula Director name (default **bacula**)

### BACULA_FDNAME

Bacula File Daemon name (default **bacula-fd**)

### BACULA_FDADDRESS

Bacula File Daemon address (default **127.0.0.1**)

### BACULA_DIRADDRESS

Bacula Director address (default **127.0.0.1**)

### BACULA_SDADDRESS

Bacula Storage Daemon address (default **127.0.0.1**)

# Docker Compose

```

version: "3.7"

services:

 postgres:
  image: postgres:alpine
  environment:
   - POSTGRES_PASSWORD=bacula
  networks:
   - bacula
  volumes:
    - catalog:/var/lib/postgresql/data
  deploy:
   replicas: 1
   restart_policy:
     condition: on-failure

 bacula-fd:
  image: glenonmateus/bacula-fd:9.4.4
  volumes:
   - bacula-fd:/etc/bacula
  environment:
   - BACULA_FDPASSWORD=password
  networks:
   - bacula
  ports:
   - 9102:9102
  deploy:
   mode: global
   restart_policy:
     condition: on-failure

 bacula-sd:
   image: glenonmateus/bacula-sd:9.4.4
  volumes:
   - bacula-sd:/etc/bacula
  environment:
   - BACULA_SDPASSWORD=password
  networks:
   - bacula
  ports:
   - 9103:9103
  deploy:
   replicas: 1
   restart_policy:
     condition: on-failure

 bacula-dir:
   image: glenonmateus/bacula-dir:9.4.4
   volumes:
    - bacula-dir:/etc/bacula
   environment:
    - BACULA_DBHOST=postgres
    - BACULA_DBNAME=baculadb
    - BACULA_DBUSER=bacula
    - BACULA_DBPASSWORD=bacula
    - BACULA_FDADDRESS=bacula-fd
    - BACULA_SDADDRESS=bacula-sd
   networks:
    - bacula
   ports:
    - 9101:9101
   depends_on:
    - postgres
    - bacula-fd
    - bacula-sd
   deploy:
    replicas: 1
    restart_policy:
      condition: on-failure

volumes:
 catalog:
 bacula-fd:
 bacula-sd:
 bacula-dir:

networks:
 bacula:

```
