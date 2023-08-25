#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

rm -f /var/db/test.db

host=$1

if [[ $host == "" ]];
then
    host="ws://localhost:8080"
    cd /skfs || exit 1
    echo "Running local server"
    make run-server > /dev/null 2>&1 &
    server_pid=$!
    i=0
    while [[ $i -lt 10 ]];
    do
        if curl http://localhost:8080 >/dev/null 2>&1; then
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
