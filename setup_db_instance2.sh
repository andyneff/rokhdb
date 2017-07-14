#!/bin/bash

# setup_db_instance.sh - Install and start a mysqld instance. Need to provide a name (for socket file and data directory) and a socket port.

##### constants

passwd=bM8BSfhqeUsPSKsg
mysql_base_port=14002
mysql_base_socket=/tmp/rokh_mysql

db_path=./Database/mariadb-10.1.11-linux-x86_64
data_base_path="$db_path/data"

##### get argument - one argument: db port

if [ $# -ne 1 ]; then
    echo "$0: usage: setup_db_instance <port>"
    exit 1
fi

# we use the port number for the db identifier as well
name=$1
mysql_port=$1

mysql_socket=$mysql_base_socket-$name.sock
db_data_path="$data_base_path/$name"

echo "Setting up mysqld instance '$name' on port $mysql_port."
echo "Database directory: $db_path"
echo "Data directory: $db_data_path"
echo "Port: $mysql_port"
echo "Socket file: $mysql_socket"

cd "${0%/*}"

#echo "Installing MySQL ..."
#echo ""

#$db_path/scripts/mysql_install_db --no-defaults --basedir=$db_path  --datadir=$db_data_path > /dev/null 2>&1

echo "Dropping rokh database"
$db_path/bin/mysql --user=root --password=$passwd --port=$mysql_port --socket=$mysql_socket <<< "drop database RokhDB;" > /dev/null 2>&1 || :

if [ $? -eq 0 ]; then
        echo "Rolling ... RokhDB_CreateDatabase.sql"
        $db_path/bin/mysql --user=root --password=$passwd --port=$mysql_port --socket=$mysql_socket < Database/RokhDB_CreateDatabase.sql > /dev/null 2>&1
fi

if [ $? -eq 0 ]; then
        echo "Rolling ... RokhDB_StoreProc.sql"
        $db_path/bin/mysql --user=root --password=$passwd --port=$mysql_port --socket=$mysql_socket < Database/RokhDB_StoreProc.sql > /dev/null 2>&1
fi

if [ $? -eq 0 ]; then
        echo "Rolling ... RokhDB_InsertDefaultData.sql"
        $db_path/bin/mysql --user=root --password=$passwd --port=$mysql_port --socket=$mysql_socket < Database/RokhDB_InsertDefaultData.sql > /dev/null 2>&1
fi

if [ $? -eq 0 ]; then
        echo "Rolling ... RokhDB_UPdateHabitat.sql"
        $db_path/bin/mysql --user=root --password=$passwd --port=$mysql_port --socket=$mysql_socket < Database/RokhDB_UpdateHabitat.sql > /dev/null 2>&1
fi

if [ $? -eq 0 ]; then
        echo ""
        echo "SUCCESS!"
        echo ""
else
        echo ""
        echo -e "FAILURE!"
        echo ""
fi



