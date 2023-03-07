#!/bin/bash

SKDB_BIN=/skfs/build/skdb

SERVER_DB=/tmp/server.db
LOCAL_DB=/tmp/local.db
SERVER_TAIL=/tmp/server_tail
LOCAL_UPDATES=/tmp/updates
LOCAL_DIFF=/tmp/localdiff

setup_server() {
    db=$SERVER_DB
    rm -f "$db"

    SKDB="$SKDB_BIN --data $db"
    $SKDB_BIN --init "$db"

    $SKDB < privacy/init.sql

    echo "INSERT INTO skdb_users VALUES(id(), 'test_user', 'pass');" | $SKDB
    echo "CREATE TABLE test (id INTEGER, note STRING);" | $SKDB
}

setup_local() {
    db=$LOCAL_DB
    rm -f "$db" "$LOCAL_UPDATES" "$LOCAL_DIFF"

    SKDB="$SKDB_BIN --data $db"
    $SKDB_BIN --init "$db"

    echo "CREATE TABLE test (id INTEGER, note STRING);" | $SKDB
}

assert_line_count() {
    file=$1
    pattern=$2
    expected_cnt=$3
    cnt=$(grep -Ec "$pattern" "$file")
    if [[ ! $cnt -eq "$expected_cnt" ]]; then
        echo "FAIL: looking for $pattern. Wanted $expected_cnt but got $cnt:"
        cat "$file"
        exit 1
    fi
}

run_test() {
    echo -n "$1.............."
    eval "$1"
    echo "PASS"
}


################################################################################
# tests demonstrating the behaviour today that we want to be able to control
################################################################################

test_write_csv_produces_updates() {
    setup_server
    setup_local
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    # client's update log mirrors it which will be sent back to the server causing a cycle
    assert_line_count "$LOCAL_UPDATES" hello 1
}

run_test test_write_csv_produces_updates

test_write_csv_tombstones() {
    setup_server
    setup_local

    # subscribe locally
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES test > /dev/null

    # write in to server - will have a unique source
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB test < $SERVER_TAIL > /dev/null

    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 1

    # delete locally
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test WHERE id = 0;"

    # we get the write from the server and our delete. but we don't want to see the delete
    assert_line_count "$LOCAL_UPDATES" hello 2
}

run_test test_write_csv_tombstones


################################################################################
# tests demonstrating that we can filter out updates we don't want to replicate
################################################################################

# write-csv: does not emit update
test_updates_filters_write_csv() {
    setup_server
    setup_local
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0
}

run_test test_updates_filters_write_csv

# write-csv; local insert: emits update
test_updates_filters_write_csv_with_local_input() {
    setup_server
    setup_local
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"
    assert_line_count "$LOCAL_UPDATES" hello 1 # output my local change for replication
}

run_test test_updates_filters_write_csv_with_local_input

# local insert; write-csv: emits update only after local insert
test_updates_filters_write_csv_with_local_input_local_write_first() {
    setup_server
    setup_local
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"
    assert_line_count "$LOCAL_UPDATES" hello 1

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 1 # still just 1
}

run_test test_updates_filters_write_csv_with_local_input_local_write_first

# write-csv; delete local: emits update
test_updates_with_tombstones_filters_write_csv() {
    setup_server
    setup_local

    # subscribe locally
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test > /dev/null

    # write in to server - will have a unique source
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    assert_line_count "$SERVER_TAIL" hello 1
    # was applied by the write-csv we're ignoring, so we shouldn't see it
    assert_line_count "$LOCAL_UPDATES" hello 0

    # delete locally
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test WHERE id = 0;"

    # we want to see our local change
    assert_line_count "$LOCAL_UPDATES" hello 1
}

run_test test_updates_with_tombstones_filters_write_csv

# write-csv; local insert; write-csv zeros out: only emit the insert
test_updates_filters_write_csv_with_local_input_then_write_csv_zeros() {
    setup_server
    setup_local
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"
    assert_line_count "$LOCAL_UPDATES" hello 1 # output my local change for replication

    # delete on server
    $SKDB_BIN --data $SERVER_DB <<< "DELETE FROM test WHERE id = 0;"

    # replicate full history down
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row - the zero out row
    assert_line_count "$SERVER_TAIL" hello 1
    # no more emits
    assert_line_count "$LOCAL_UPDATES" hello 1
}

run_test test_updates_filters_write_csv_with_local_input_then_write_csv_zeros

# write-csv; local identity update: emit update
test_updates_filters_write_csv_with_local_identity_update() {
    setup_server
    setup_local
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    # local update that doesn't change the row
    $SKDB_BIN --data $LOCAL_DB <<< "UPDATE test SET note = 'hello' WHERE id = 0;"
    assert_line_count "$LOCAL_UPDATES" hello 1 # output my local change for replication
}

run_test test_updates_filters_write_csv_with_local_identity_update


################################################################################
# tests demonstrating that we can filter out diff output we don't want to resync
################################################################################

# write-csv: does not emit on diff
test_diff_filters_write_csv() {
    setup_server
    setup_local
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    # simulate reconnect
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    assert_line_count "$LOCAL_DIFF" hello 0
}

run_test test_diff_filters_write_csv

# write-csv; local insert: emit the row
test_diff_filters_write_csv_mixed_with_local_input() {
    setup_server
    setup_local
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    assert_line_count "$LOCAL_DIFF" hello 0

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"

    [[ $($SKDB_BIN --data $LOCAL_DB <<< "select count(*) from test where note = 'hello';") -eq 2 ]] || exit 1

    # simulate reconnect
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    # there was a local write so we need to send this
    assert_line_count "$LOCAL_DIFF" hello 1
}

run_test test_diff_filters_write_csv_mixed_with_local_input

# local insert; write-csv: don't emit the row. the current state is due to replication.
test_diff_filters_write_csv_mixed_with_local_input_write_first() {
    setup_server
    setup_local
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"
    assert_line_count "$LOCAL_UPDATES" hello 1

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 1 # still 1

    # we end up with just one row. the write-csv clobbers our local
    # write. this is expected as we have no conflict prevention, so
    # the write is lost.
    [[ $($SKDB_BIN --data $LOCAL_DB <<< "select count(*) from test where note = 'hello';") -eq 1 ]] || exit 1

    # simulate reconnect
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    # we send none as our local data was lost and this is all imported now.
    assert_line_count "$LOCAL_DIFF" hello 0
}

run_test test_diff_filters_write_csv_mixed_with_local_input_write_first

# write-csv; delete local: emit the row
test_diff_filters_write_csv_mixed_with_local_delete() {
    setup_server
    setup_local
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    # delete locally
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test WHERE id = 0;"

    # simulate reconnect
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    # there was a local write so we need to send this
    assert_line_count "$LOCAL_DIFF" hello 1
}

run_test test_diff_filters_write_csv_mixed_with_local_delete

# write-csv; local insert; write-csv zeros out: don't emit the row. the current state is due to replication.
test_diff_filters_write_csv_mixed_with_local_input_then_write_csv_zeros() {
    setup_server
    setup_local
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # write csv zeros
    $SKDB_BIN --data $SERVER_DB <<< "DELETE FROM test WHERE id = 0;"
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null
    # server sent down 1 row - the zeroed out row
    assert_line_count "$SERVER_TAIL" hello 1

    # simulate reconnect
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    # there was a local write so we need to send this
    assert_line_count "$LOCAL_DIFF" hello 0
}

run_test test_diff_filters_write_csv_mixed_with_local_input_then_write_csv_zeros

# write-csv; local identity update: emit
test_diff_filters_write_csv_mixed_with_local_update() {
    setup_server
    setup_local
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 'test-script' test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "UPDATE test SET note = 'hello' WHERE id = 0;"

    # simulate reconnect
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    # there was a local update so we need to send this
    assert_line_count "$LOCAL_DIFF" hello 1
}

run_test test_diff_filters_write_csv_mixed_with_local_update


################################################################################
# tail. just for sanity, we have a test for tailing as the server will
# use this. it's the same mechanism as updates so we don't duplicate
# the testing.
################################################################################

test_server_tail_filters_write_csv() {
    setup_server
    setup_local

    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 'test-script' test)
    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source test_user test)

    # write in to local
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate diff to server
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    $SKDB_BIN write-csv --data $SERVER_DB --source 'test_user' --user test_user test < $LOCAL_DIFF > /dev/null

    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL

    assert_line_count "$LOCAL_DIFF" hello 1
    # server does not echo
    assert_line_count "$SERVER_TAIL" hello 0
}

run_test test_server_tail_filters_write_csv
