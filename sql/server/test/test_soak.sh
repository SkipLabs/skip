#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

BUILD=/skfs/build
SKDB_BIN=$BUILD/skdb

SERVER_PID_FILE=$(mktemp)
SERVER_DB=/var/db/soak.db

handle_term() {
    kill "$(cat "$SERVER_PID_FILE")"
    kill "$client1"
    kill "$client2"
    rm -f "$SERVER_PID_FILE"
}
trap 'handle_term' EXIT

run_server() {
    rm -f "$SERVER_DB"

    "$SCRIPT_DIR"/../deploy/create_db.sh soak abcdef

    SKDB="$SKDB_BIN --data $SERVER_DB"

    (echo "BEGIN TRANSACTION;";
     echo "INSERT INTO skdb_users VALUES(1, 'test_user1', 'test');"
     echo "INSERT INTO skdb_users VALUES(2, 'test_user2', 'test');"
     echo "COMMIT;"
    ) | $SKDB

    # these tables are for inserts only. there should be no conflict
    echo "CREATE TABLE no_pk_inserts (id INTEGER, client INTEGER, value INTEGER, skdb_access INTEGER NOT NULL);" | $SKDB

    "$SCRIPT_DIR"/../deploy/chaos.sh 90 > /tmp/soak-server-log &

    echo $! > "$SERVER_PID_FILE"
}

echo "Starting server..."
run_server

# TODO: should wait on some signal from the server
sleep 10

cd /skfs/sql/js || exit 1

echo "Starting clients..."

client1_out=/tmp/client1.out
client2_out=/tmp/client2.out

/usr/bin/env node ../server/test/soak_client.mjs 1 > $client1_out 2>&1 &
client1=$!

/usr/bin/env node ../server/test/soak_client.mjs 2 > $client2_out 2>&1 &
client2=$!

echo "To monitor progress:"
echo "tail -F /tmp/soak-server-log"
echo '/skfs/build/skdb --data /var/db/soak.db <<< "select * from no_pk;"'

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
