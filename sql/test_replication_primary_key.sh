#!/bin/bash

SKDB_BIN=/skfs/build/skdb
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SERVER_DB=/tmp/server.db
LOCAL_DB=/tmp/local.db
UPDATES=/tmp/updates
WRITE_OUTPUT=/tmp/write-out
SESSION=/tmp/session

setup_server() {
    db=$SERVER_DB
    rm -f "$db" "$WRITE_OUTPUT"

    SKDB="$SKDB_BIN --data $db"
    $SKDB_BIN --init "$db"

    $SKDB < "$SCRIPT_DIR/privacy/init.sql"

    (echo "BEGIN TRANSACTION;";
     echo "INSERT INTO skdb_users VALUES(id('user'), 'test_user', 'test');"
     echo "COMMIT;"
    ) | $SKDB

    echo "CREATE TABLE test_with_pk (id INTEGER PRIMARY KEY, note STRING);" | $SKDB
}

setup_local() {
    table=$1
    db=$LOCAL_DB
    rm -f "$db" "$UPDATES"

    SKDB="$SKDB_BIN --data $db"
    $SKDB_BIN --init "$db"

    echo "CREATE TABLE test_with_pk (id INTEGER PRIMARY KEY, note STRING);" | $SKDB

    $SKDB_BIN subscribe --data $LOCAL_DB --connect --format=csv --updates $UPDATES --ignore-source 9999 "$table" > $SESSION
}

replicate_to_local() {
    table=$1
    sub=$($SKDB_BIN --data $SERVER_DB subscribe --connect --user test_user --ignore-source 1234 "$table")
    $SKDB_BIN --data $SERVER_DB tail --format=csv --since 0 "$sub" |
        $SKDB_BIN write-csv "$table" --data $LOCAL_DB --source 9999 > $WRITE_OUTPUT
}

replicate_to_server() {
    table=$1
    cat $UPDATES | $SKDB_BIN write-csv "$table" --data $SERVER_DB --source 1234 --user test_user > $WRITE_OUTPUT
}

replicate_diff_to_server() {
    table=$1
    since=$2
    $SKDB_BIN --data $LOCAL_DB diff --format=csv --since "$since" "$(cat $SESSION)" |
        $SKDB_BIN write-csv "$table" --data $SERVER_DB --source 1234 --user test_user > $WRITE_OUTPUT
}

run_test() {
    echo -n "$1.............."
    eval "$1"
    echo "PASS"
}

debug() {
    echo
    echo --------------------------------------
    echo "$1"

    echo current updates state:
    cat $UPDATES

    echo last write-csv response:
    cat $WRITE_OUTPUT

    echo local state:
    $SKDB_BIN --data $LOCAL_DB <<< "select * from test_with_pk;"

    echo server state:
    $SKDB_BIN --data $SERVER_DB <<< "select * from test_with_pk;"
    echo --------------------------------------
}

fail() {
    echo FAIL
    exit 1
}

assert_line_count() {
    file=$1
    pattern=$2
    expected_cnt=$3
    cnt=$(grep -Ec "$pattern" "$file")
    if [[ ! $cnt -eq "$expected_cnt" ]]
    then
        echo "FAIL: looking for $pattern. Wanted $expected_cnt but got $cnt:"
        echo "This was the input:"
        cat "$file"
        exit 1
    fi
}

assert_server_rows_has() {
    expected=$1
    pattern=$2
    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" "$pattern" "$expected"
    rm -f "$output"
}

################################################################################
# basic replication scenarios
################################################################################

test_basic_replication_unique_rows() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(1,'bar');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(2,'baz');"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    assert_line_count "$output" bar 1
    assert_line_count "$output" baz 1
    rm -f "$output"
}

test_basic_replication_unique_rows_replayed() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(1,'bar');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(2,'baz');"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    assert_line_count "$output" bar 1
    assert_line_count "$output" baz 1
    rm -f "$output"

    # simulate a reconnect - resend everything
    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    assert_line_count "$output" bar 1
    assert_line_count "$output" baz 1
    rm -f "$output"
}

test_basic_replication_unique_rows_server_state_different() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    output=$(mktemp)
    $SKDB_BIN --data $LOCAL_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"

    replicate_to_server test_with_pk

    # different writers so they combine
    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
}

test_basic_replication_null_string() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "UPDATE test_with_pk SET note = NULL WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)

    $SKDB_BIN --data $SERVER_DB <<< "SELECT COUNT(*) FROM test_with_pk WHERE note is NULL;" > "$output"
    assert_line_count "$output" 1 1
    $SKDB_BIN --data $SERVER_DB <<< "SELECT COUNT(*) FROM test_with_pk WHERE note = '';" > "$output"
    assert_line_count "$output" 0 1

    session=$($SKDB_BIN --data $SERVER_DB subscribe test_with_pk --connect --user test_user)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > "$output"
    # we want the output to contain a null representation
    assert_line_count "$output" "1	0,$" 1
    rm -f "$output"
}

test_basic_replication_empty_string() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "UPDATE test_with_pk SET note = '' WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)

    $SKDB_BIN --data $SERVER_DB <<< "SELECT COUNT(*) FROM test_with_pk WHERE note is NULL;" > "$output"
    assert_line_count "$output" 0 1
    $SKDB_BIN --data $SERVER_DB <<< "SELECT COUNT(*) FROM test_with_pk WHERE note = '';" > "$output"
    assert_line_count "$output" 1 1

    session=$($SKDB_BIN --data $SERVER_DB subscribe test_with_pk --connect --user test_user)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$session" --since 0 > "$output"
    # we want the output to contain an empty string
    assert_line_count "$output" '""' 1
    rm -f "$output"
}

test_basic_replication_with_deletes() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_server test_with_pk
    assert_server_rows_has 1 foo

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    replicate_to_server test_with_pk
    assert_server_rows_has 0 foo

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    replicate_to_server test_with_pk
    assert_server_rows_has 0 foo

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_server test_with_pk
    assert_server_rows_has 1 foo
}

test_basic_replication_with_deletes_server_state_different() {
    setup_server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    setup_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    replicate_to_server test_with_pk

    # we still have the record as this was concurrently written
    assert_server_rows_has 1 foo
}

################################################################################
# these tests replicate data around first so we build some notion of
# the vector clock and test concurrency
################################################################################

test_seen_insert_deleted() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 0
    rm -f "$output"
}

test_unseen_insert_not_deleted() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    # but not this
    $SKDB_BIN --data $SERVER_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    # concurrently:
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
}

test_unseen_insert_added_to() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    # but not this
    $SKDB_BIN --data $SERVER_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    # concurrently:
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
}

test_seen_insert_clobbered() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    $SKDB_BIN --data $LOCAL_DB <<< "UPDATE test_with_pk SET note='bar' WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 0
    assert_line_count "$output" bar 1
    rm -f "$output"
}

test_unseen_insert_not_updated() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    # but not this
    $SKDB_BIN --data $SERVER_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    # concurrently:
    $SKDB_BIN --data $LOCAL_DB <<< "UPDATE test_with_pk SET note='bar' WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    # tiebreak the concurrency: foo wins because the foo row > bar row
    assert_line_count "$output" foo 1
    assert_line_count "$output" bar 0
    rm -f "$output"
}

test_unseen_update_is_updated() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    # but not this
    $SKDB_BIN --data $SERVER_DB <<< "UPDATE test_with_pk SET note='bar' WHERE id = 0;"
    # concurrently:
    $SKDB_BIN --data $LOCAL_DB <<< "UPDATE test_with_pk SET note='baz' WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    # tiebreak the concurrency: foo wins because the foo row > bar row
    assert_line_count "$output" foo 0
    assert_line_count "$output" bar 0
    assert_line_count "$output" baz 1
    rm -f "$output"
}

test_unseen_update_is_not_updated() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    # but not this
    $SKDB_BIN --data $SERVER_DB <<< "UPDATE test_with_pk SET note='baz' WHERE id = 0;"
    # concurrently:
    $SKDB_BIN --data $LOCAL_DB <<< "UPDATE test_with_pk SET note='bar' WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    # tiebreak the concurrency: foo wins because the foo row > bar row
    assert_line_count "$output" foo 0
    assert_line_count "$output" bar 0
    assert_line_count "$output" baz 1
    rm -f "$output"
}

test_unseen_insert_is_updated() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    # but not this
    $SKDB_BIN --data $SERVER_DB <<< "UPDATE test_with_pk SET note='bar' WHERE id = 0;"
    # concurrently:
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    # tiebreak the concurrency: foo wins because the foo row > bar row
    assert_line_count "$output" foo 1
    assert_line_count "$output" bar 0
    rm -f "$output"
}

test_unseen_delete_gets_clobbered() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    # but not this
    $SKDB_BIN --data $SERVER_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    # concurrently:
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_server test_with_pk

    # the client now asserts there should be two rows. our concurrency
    # model is that inserts always beat deletes and need to be
    # resolved.
    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
}

test_unseen_delete_does_not_affect_delete() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    # local has seen up to 0,'foo'
    # but not this
    $SKDB_BIN --data $SERVER_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    # concurrently:
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"

    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 0
    rm -f "$output"
}

# TODO: dup these tests with updates. one update should be a value >
# and another set of dups for one <

# AA - idempotentency
test_reconnect_replayed() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_server test_with_pk
    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
}

# AB - commutativity
test_replayed_with_more_local_data() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_server test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
}

# AB - commutativity
test_reconnect_replayed_with_more_local_data() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"

    replicate_to_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_server test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    # this is a reconnect, we figure out the diff
    replicate_diff_to_server test_with_pk 0

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
}

# BA - commutativity
test_old_diff_replayed() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    # stash what would have been sent up
    save=$(mktemp)
    cp $UPDATES "$save"

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_server test_with_pk

    # restore and replay
    mv "$save" $UPDATES
    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
    rm -f "$save"
}

# BA - commutativity
test_reconnect_old_diff_replayed() {
    setup_server
    setup_local test_with_pk

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_to_local test_with_pk

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    # stash what would have been sent up
    save=$(mktemp)
    cp $UPDATES "$save"

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_with_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_with_pk VALUES(0,'foo');"
    replicate_diff_to_server test_with_pk 0

    # restore and replay
    mv "$save" $UPDATES
    replicate_to_server test_with_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_with_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
    rm -f "$save"
}


# tests:
run_test test_basic_replication_unique_rows
run_test test_basic_replication_unique_rows_replayed

run_test test_basic_replication_unique_rows_server_state_different

run_test test_basic_replication_null_string
run_test test_basic_replication_empty_string

run_test test_basic_replication_with_deletes
run_test test_basic_replication_with_deletes_server_state_different

# local updates
run_test test_seen_insert_deleted
run_test test_unseen_insert_not_deleted
run_test test_unseen_insert_added_to
run_test test_seen_insert_clobbered
run_test test_unseen_insert_not_updated
run_test test_unseen_update_is_updated
run_test test_unseen_update_is_not_updated
run_test test_unseen_insert_is_updated
run_test test_unseen_delete_gets_clobbered
run_test test_unseen_delete_does_not_affect_delete

# still have idempotence and commutativity
run_test test_reconnect_replayed
run_test test_replayed_with_more_local_data
run_test test_reconnect_replayed_with_more_local_data
run_test test_old_diff_replayed
run_test test_reconnect_old_diff_replayed
