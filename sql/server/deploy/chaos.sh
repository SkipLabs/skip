#!/bin/bash
#
# start the server and behave chaotically to test end-to-end resilience

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "/root/.sdkman/bin/sdkman-init.sh"

cd $SCRIPT_DIR/../skgw

################################################################################
# start server in background
################################################################################

SERVER_PID_FILE=/tmp/server.pid

function start_server {
    gradle --console plain run >/tmp/server.log 2>&1 &
    pid=$!
    echo $pid > $SERVER_PID_FILE
    echo "started server: $pid"
}

start_server

if [[ -z $(cat $SERVER_PID_FILE) ]]
then
    echo "couldn't start server"
    exit 1
fi

handle_term() {
    kill $(cat $SERVER_PID_FILE)
    exit 0
}
trap 'handle_term' SIGTERM SIGINT


################################################################################
# behave chaotically
################################################################################

function kill_random_skdb_pid {
    # TODO: figure out how to only target processes that were recursively
    # spawned by the server_pid
    pid=$(pgrep -f "skdb.*$1" | shuf -n 1)
    if [[ ! -z $pid ]]
    then
        echo kill_random_skdb_pid: $1, $2, $pid
        kill $2 $pid
        echo $?
    fi
}

function restart_server {
    pid=$(cat $SERVER_PID_FILE)
    echo restart_server: $pid
    kill -TERM $pid
    wait $pid
    sleep $1
    start_server
}

targets[0]="restart_server 0"
targets[1]="restart_server 1"
targets[2]="restart_server 5"
targets[3]="kill_random_skdb_pid tail -TERM"
targets[4]="kill_random_skdb_pid tail -KILL"
targets[5]="kill_random_skdb_pid tail -ABRT"
# simulates a hung process
targets[6]="kill_random_skdb_pid tail -STOP"

# targets[2]="kill_random_skdb_pid write-csv"

# TODO: more signals than just term
# TODO: target a proxy
# TODO: mess with the network

while true
do
    sleep 10
    rand=$(( $RANDOM % ${#targets[@]} ))
    cmd=${targets[$rand]}
    eval $cmd
done

wait $SERVER_PID
