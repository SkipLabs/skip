#!/bin/bash
#
# start the server and behave chaotically to test end-to-end resilience

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


if [ -d ~/.sdkman ]
then
    SDKMAN=$(realpath ~/.sdkman)
else
    SDKMAN=/root/.sdkman
fi

source "$SDKMAN/bin/sdkman-init.sh"

cd $SCRIPT_DIR/../dev

################################################################################
# start server in background
################################################################################

SERVER_PID_FILE=$(mktemp)
PAUSED_PROCS_FILE=/tmp/chaos_paused_pids
rm -f $PAUSED_PROCS_FILE
SERVER_LOG=/tmp/server.log

if [ -f ~/.skdb/config.prop ];then
    file=$(realpath ~/.skdb/config.prop)
    SERVER_ARGS="--args=\"--config $file\""
else
    SERVER_ARGS=
fi

function start_server {
    gradle --console plain run $SERVER_ARGS > $SERVER_LOG 2>&1 &
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
    # resume any paused processes so they can go down with the ship.
    # CONT should be idempotent
    cat $PAUSED_PROCS_FILE|xargs kill -CONT >/dev/null 2>&1
    kill "$(cat "$SERVER_PID_FILE")"
    rm -f "$SERVER_PID_FILE"
    rm -f $PAUSED_PROCS_FILE
}
trap 'handle_term' EXIT

monitor() {
    # currently don't do anything in response
    echo "Received SIGUSR1"
}
trap 'monitor' SIGUSR1


################################################################################
# behave chaotically
################################################################################

function kill_random_skdb_pid {
    # TODO: figure out how to only target processes that were recursively
    # spawned by the server_pid
    proc_type=$1
    signal=$2
    pid=$(pgrep -f "skdb.*$proc_type" | shuf -n 1)
    if [[ ! -z $pid ]]
    then
        if [[ $signal == "-STOP" ]]
        then
            echo $pid >> $PAUSED_PROCS_FILE
        fi
        kill $signal $pid
        echo kill_random_skdb_pid: $proc_type, $signal, $pid, $?
    fi
}

function restart_server {
    wait_to_restart=$1
    pid=$(cat $SERVER_PID_FILE)
    kill -TERM $pid
    echo restart_server: $pid, $?, $wait_to_restart
    wait $pid
    sleep $wait_to_restart
    start_server
}

delay_secs=10
if [[ ! -z $1 ]]
then
    delay_secs=$1
fi
echo "Will do something chaotic every $delay_secs seconds"

targets=(
    "restart_server 0"
    "restart_server 1"
    "restart_server 60"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"
    "restart_server 120"

    "kill_random_skdb_pid tail -TERM"
    "kill_random_skdb_pid tail -KILL"
    "kill_random_skdb_pid tail -ABRT"

    "kill_random_skdb_pid write-csv -TERM"
    "kill_random_skdb_pid write-csv -KILL"
    "kill_random_skdb_pid write-csv -ABRT"

    # simulates a hung process
    "kill_random_skdb_pid tail -STOP"
    "kill_random_skdb_pid write-csv -STOP"
    # that can recover
    "kill_random_skdb_pid tail -CONT"
    "kill_random_skdb_pid write-csv -CONT"
)

while true
do
    sleep $delay_secs &
    wait $!
    rand=$(( $RANDOM % ${#targets[@]} ))
    cmd=${targets[$rand]}
    eval $cmd
done

wait $SERVER_PID
