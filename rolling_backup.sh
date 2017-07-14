#!/usr/bin/env bash

while : ; do
  for ((x=0; x<10; x++)); do
    echo "Backup $x"
    ./Database/mariadb-10.1.11-linux-x86_64/bin/mysqldump RokhDB --user=root --port ${1-14002} --socket /tmp/rokh_mysql-${1-14002}.sock --password=bM8BSfhqeUsPSKsg > auto_backup_$x.sql
    sleep 3600
  done
done
