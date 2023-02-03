#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BUILD=/skfs/build
SKDB_BIN=$BUILD/skdb

SERVER_PID_FILE=/tmp/server.pid
SERVER_DB=/var/db/soak.db

handle_term() {
    kill "$(cat "$SERVER_PID_FILE")"
    exit 1
}
trap 'handle_term' SIGTERM SIGINT

run_server() {
    rm -f "$SERVER_DB"

    "$SCRIPT_DIR"/../deploy/create_db.sh soak

    SKDB="$SKDB_BIN --data $SERVER_DB"

    (echo "BEGIN TRANSACTION;";
     echo "INSERT INTO skdb_users VALUES(1, 'test_user1', 'pass');"
     echo "INSERT INTO skdb_users VALUES(2, 'test_user2', 'pass');"
     echo "COMMIT;"
    ) | $SKDB

    echo "CREATE TABLE log (id INTEGER, client INTEGER, value INTEGER, skdb_access INTEGER NOT NULL, skdb_owner INTEGER);" | $SKDB

    # something nasty happens every 5 mins
    "$SCRIPT_DIR"/../deploy/chaos.sh 300 > /tmp/soak-server-log &

    echo $! > $SERVER_PID_FILE
}

echo "Starting server..."
run_server

# TODO: should wait on some signal from the server
sleep 10

cd $BUILD || exit 1

echo "Starting clients..."

client1_out=/tmp/client1.out
client2_out=/tmp/client2.out

../sql/node/run_node.sh ../sql/server/test/soak_client.js 1 > $client1_out 2>&1 &
client1=$!

../sql/node/run_node.sh ../sql/server/test/soak_client.js 2 > $client2_out 2>&1 &
client2=$!

echo "To monitor progress:"
echo "tail -F /tmp/soak-server-log"
echo '/skfs/build/skdb --data /var/db/soak.db <<< "select * from log;"'

wait $client1 $client2

kill "$(cat "$SERVER_PID_FILE")"

if [[ -z $(diff -q $client1_out $client2_out) ]]
then
    echo PASS
    exit 0
else
    echo FAIL
    echo 1:
    cat $client1_out
    echo 2:
    cat $client2_out
    exit 1
fi
