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
    echo "INSERT INTO skdb_users VALUES(99, 'test_alt_user', 'pass');" | $SKDB

    echo "CREATE TABLE whitelist_just_alt_user(userID INTEGER);" | $SKDB
    echo "INSERT INTO whitelist_just_alt_user VALUES (99);" | $SKDB
    echo "INSERT INTO skdb_access VALUES (2, 2, -1, 'alt user');" | $SKDB
    echo "INSERT INTO skdb_groups VALUES (2, 'whitelist_just_alt_user');" | $SKDB

    echo "CREATE TABLE test (id INTEGER, note STRING);" | $SKDB
    echo "CREATE TABLE test_with_access (id INTEGER, note STRING, skdb_access INTEGER);" | $SKDB
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
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0
}

run_test test_updates_filters_write_csv

# write-csv; local insert: emits update
test_updates_filters_write_csv_with_local_input() {
    setup_server
    setup_local
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

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
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test > /dev/null

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
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 2 # update with more output to reflect there are now 2

    # server sends down again for some reason
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null
    assert_line_count "$LOCAL_UPDATES" hello 2 # still just the same 2 updates
}

run_test test_updates_filters_write_csv_with_local_input_local_write_first

# write-csv; delete local: emits update
test_updates_with_tombstones_filters_write_csv() {
    setup_server
    setup_local

    # subscribe locally
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test > /dev/null

    # write in to server - will have a unique source
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

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
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

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
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

    # server sent down 1 row - the zero out row
    assert_line_count "$SERVER_TAIL" hello 1
    # we emit an update - we now only have 1 row
    assert_line_count "$LOCAL_UPDATES" hello 2

    # replicate full history down again
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null
    # still only have the two
    assert_line_count "$LOCAL_UPDATES" hello 2
}

run_test test_updates_filters_write_csv_with_local_input_then_write_csv_zeros

# write-csv; local identity update: emit update
test_updates_filters_write_csv_with_local_identity_update() {
    setup_server
    setup_local
    $SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test > /dev/null

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # we haven't seen the update yet
    assert_line_count "$LOCAL_UPDATES" hello 0

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

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
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

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
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

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
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"
    assert_line_count "$LOCAL_UPDATES" hello 1

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 2 # we update from 1 to 2

    # replicate full history to local again
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

    # the write-csv does not clobber our local write.
    [[ $($SKDB_BIN --data $LOCAL_DB <<< "select count(*) from test where note = 'hello';") -eq 2 ]] || exit 1

    # simulate reconnect
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    # we send something up because our local data isn't lost
    assert_line_count "$LOCAL_DIFF" hello 1
}

run_test test_diff_filters_write_csv_mixed_with_local_input_write_first

# write-csv; delete local: emit the row
test_diff_filters_write_csv_mixed_with_local_delete() {
    setup_server
    setup_local
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

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
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

    # server sent down 1 row
    assert_line_count "$SERVER_TAIL" hello 1
    assert_line_count "$LOCAL_UPDATES" hello 0

    # local change
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # write csv zeros
    $SKDB_BIN --data $SERVER_DB <<< "DELETE FROM test WHERE id = 0;"
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null
    # server sent down 1 row - the zeroed out row
    assert_line_count "$SERVER_TAIL" hello 1

    # simulate reconnect
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    # there was a local write so we need to send this
    assert_line_count "$LOCAL_DIFF" hello 1
}

run_test test_diff_filters_write_csv_mixed_with_local_input_then_write_csv_zeros

# write-csv; local identity update: emit
test_diff_filters_write_csv_mixed_with_local_update() {
    setup_server
    setup_local
    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test)

    # write in to server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate full history to local
    rm -f "$SERVER_TAIL"
    session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > $SERVER_TAIL
    $SKDB_BIN write-csv --data $LOCAL_DB --source 1234 test < $SERVER_TAIL > /dev/null

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

    local_session=$($SKDB_BIN subscribe --format=csv --data $LOCAL_DB --connect --updates $LOCAL_UPDATES --ignore-source 1234 test)
    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)

    # write in to local
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test VALUES(0,'hello');"

    # replicate diff to server
    $SKDB_BIN diff --data $LOCAL_DB --format=csv --since 0 "$local_session" > $LOCAL_DIFF
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test < $LOCAL_DIFF > /dev/null

    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL

    assert_line_count "$LOCAL_DIFF" hello 1
    # server does not echo
    assert_line_count "$SERVER_TAIL" hello 0
}

run_test test_server_tail_filters_write_csv


################################################################################
# test behaviour around resets
################################################################################


# we do not want the ignore-source filter to be applied when there is a reset
test_ignore_source_ignored_on_reset() {
    setup_server

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)

    # 710: binary searched to find the first point where the reset will be generated
    for i in $(seq 710)
    do
        $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test > /dev/null << EOF


0	$i,"a"
1	$((i+1)),"a"
EOF
    done

    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL

    # we just output the final row: 1\t1001,"a" and a reset of course
    assert_line_count "$SERVER_TAIL" '710,"a"' 0
    assert_line_count "$SERVER_TAIL" '711,"a"' 1
    assert_line_count "$SERVER_TAIL" '		' 1
}

run_test test_ignore_source_ignored_on_reset


# if a client sends up a reset it should not wipe out all the rows
# they can't see due to e.g. privacy
test_server_should_apply_client_reset_to_their_subset_view_of_data() {
    setup_server

    # write a row as the source under test
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test_with_access << EOF


1	0,"foo",-1
EOF

    # write a row as another source, but with a private access value
    $SKDB_BIN write-csv --data $SERVER_DB --source 999 --user test_alt_user test_with_access << EOF


1	6,"erase",-1
1	7,"keep",2
EOF

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test_with_access)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL

    # just sanity check that test_user can see erase but not keep
    assert_line_count "$SERVER_TAIL" 'erase' 1
    assert_line_count "$SERVER_TAIL" 'keep' 0

    # now the source under test sends up a reset for whatever reason -
    # maybe reconnect. it wipes out its own foo value and the erase
    # from test_alt_user. but not the keep, because it can't see this
    # row.
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test_with_access << EOF


1	1,"baz",-1
1	2,"quux",-1
		
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test_with_access" > $SERVER_TAIL

    assert_line_count "$SERVER_TAIL" '1\|baz' 1
    assert_line_count "$SERVER_TAIL" '2\|quux' 1
    assert_line_count "$SERVER_TAIL" '7\|keep' 1
    assert_line_count "$SERVER_TAIL" '0\|foo' 0
    assert_line_count "$SERVER_TAIL" '0\|erase' 0
}

run_test test_server_should_apply_client_reset_to_their_subset_view_of_data


# if a client sends up a reset it should not wipe out local writes that haven't sync'd
test_server_should_apply_client_reset_only_to_writes_seen() {
    setup_server

    # write a row as the source under test
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test > /dev/null << EOF


1	0,"foo"
:10
EOF

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES(7,'new');"
    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL

    # if we did replicate now we would get the new row
    assert_line_count "$SERVER_TAIL" 'new' 1
    # sanity check the tick value - it's important for later - we're at 46 they're at 10
    assert_line_count "$SERVER_TAIL" ':46 10' 1

    # now the source under test sends up a reset for whatever reason -
    # maybe reconnect. it wipes out its own foo value but not the new,
    # because it hasn't seen this row yet: 35 < 46.
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test > /dev/null << EOF


1	1,"baz"
1	2,"quux"
		
:22 35
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL

    assert_line_count "$SERVER_TAIL" '1\|baz' 1
    assert_line_count "$SERVER_TAIL" '2\|quux' 1
    assert_line_count "$SERVER_TAIL" '0\|foo' 0
    assert_line_count "$SERVER_TAIL" '7\|new' 1
}

run_test test_server_should_apply_client_reset_only_to_writes_seen


# replay write-csv exactly but with checkpoint and snapshot increased so it takes affect
# should still be idempotent
test_server_write_csv_idempotent_even_when_bumped() {
    setup_server

    # write a row as the source under test
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test > /dev/null << EOF


1	0,"foo"
:10
EOF

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL

    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test > /dev/null << EOF


1	0,"foo"
:20 1000
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL

    assert_line_count "$SERVER_TAIL" '0\|foo' 1
}

run_test test_server_write_csv_idempotent_even_when_bumped

# replay write-csv exactly but with checkpoint and snapshot increased so it takes affect
# and with a reset - should still be idempotent
test_server_write_csv_idempotent_even_when_bumped_and_reset() {
    setup_server

    # write a row as the source under test
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test > /dev/null << EOF


1	0,"foo"
:10
EOF

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL

    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test > /dev/null << EOF


1	0,"foo"
		
:20 1000
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL

    assert_line_count "$SERVER_TAIL" '0\|foo' 1
}

run_test test_server_write_csv_idempotent_even_when_bumped_and_reset


# if two clients reconnect concurrently (due to e.g. server crash)
# they may send up concurrent resets and duplicate the world. ensure
# this doesn't happen
test_resets_are_aggressively_nooped() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':48' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 48
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 48
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL
    cat $SERVER_TAIL

    # just one of each
    assert_line_count "$SERVER_TAIL" '0\|foo' 1
    assert_line_count "$SERVER_TAIL" '1\|bar' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
}

run_test test_resets_are_aggressively_nooped

# same as above but one of the clients is contributing a change
test_resets_are_aggressively_nooped_but_we_do_not_lose_an_update() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':48' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 48
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test > /dev/null << EOF


1	1,"bar"
1	2,"baz"
1	3,"quux"
		
:10 48
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL
    cat $SERVER_TAIL

    # just one of each. foo is still here as it was added concurrently and adds beat deletes
    assert_line_count "$SERVER_TAIL" '0\|foo' 1
    assert_line_count "$SERVER_TAIL" '1\|bar' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
    assert_line_count "$SERVER_TAIL" '3\|quux' 1
}

run_test test_resets_are_aggressively_nooped_but_we_do_not_lose_an_update
