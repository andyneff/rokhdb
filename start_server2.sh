#!/bin/bash

# start_server.sh - Start a server with a specific id

##### Constant

infofile=./.rokhservers/servers.info


##### get arguments

if [ $# -ne 1 ]; then
    echo "$0: usage: start_server.sh <server id>"
    exit 1
fi

server_id=$1

if [ ! -f "$infofile" ];
then
   echo "ERROR: File $infofile does not exist." >&2
   echo "Make sure you create the game server first using the 'create_server.sh' script." >&2
   exit -1
fi

function check_running
{
   local id_to_check=$2
   local id="$(echo $1 | cut -f1 -d'.')"
   server_name="$(echo $1 | cut -f2 -d'.')"

   if [ "$id_to_check" == "$id" ]; then
      echo "Server '$server_name' ($id) is already running."
      exit 1
   fi
   exit 0
}  

function start_params
{
   local id_to_check=$2
   local server_name="$(echo $1 | cut -f1 -d'|')"
   local server_map="$(echo $1 | cut -f3 -d'|')"
   local server_params="$(echo $1 | cut -f4 -d'|')"
   id="$(echo $1 | cut -f2 -d'|')"

   if [ "$id_to_check" == "$id" ]; then
      echo "$server_map $server_params"
      exit 1
   fi
   exit 0
}  

# check if server is already running, this function will exit the script if the server is running
echo Checking running instances...

while read data
do
    out=$(check_running "$data" $server_id)
    res=$?
    if [ "$res" -eq 1 ]; then
      echo "Server already running ($server_id), exiting."
      exit 0
    fi
done < <(screen -ls | grep rokh_server)

echo Ok.
echo Starting Rokh dedicated server with id $server_id...

# this will get the launch parameters from the server.info file and launch the game server with those.

while read data
do
    out=$(start_params "$data" $server_id)
    res=$?
    start_arguments=$out
    if [ "$res" -eq 1 ]; then
      echo "Launching external process..."
      Rokh/Binaries/Linux/RokhServer $start_arguments -log
    fi
done < <(cat $infofile)

echo Done ! 

exit
