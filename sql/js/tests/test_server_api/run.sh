#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -f ~/.skdb/config.prop ]
then
    file=$(realpath ~/.skdb/config.prop)
    while IFS='=' read -r key value
    do
        eval ${key}="\${value}"
    done < "$file"
fi

if [[ -z "$skdb_databases" ]];
then
    skdb_databases=/var/db
fi

if [[ -z "$skdb_port" ]];
then
    skdb_port=8080
fi

SKFS_DIR=$(realpath $SCRIPT_DIR/../../../..)

export SKFS_DIR
export skdb_port
export skdb_databases

rm -f $skdb_databases/test.db

host=$1

if [[ $host == "" ]];
then
    host="ws://localhost:$skdb_port"
    cd $SKFS_DIR || exit 1
    echo "Running local server"
    make run-server &> ~/.skdb/server.log &
    server_pid=$!
    i=0
    while [[ $i -lt 10 ]];
    do
        if curl http://localhost:$skdb_port >/dev/null 2>&1; then
            echo "Server is running"
            break;
        fi
        sleep 1
        i=$((i+1))
    done
fi

echo "Running tests against: $host"

key=$(jq -r ".[\"$host\"].skdb_service_mgmt.root" < ~/.skdb/credentials)

if [[ $key == "" ]];
then
    echo "Could not find key in credentials file." >&2
    exit 1
fi

node "$SCRIPT_DIR"/index.mjs "$key" "$host"

if [[ -z "$server_pid" ]];
then
    exit 0
fi

kill "$server_pid"
wait "$server_pid"

exit 0
