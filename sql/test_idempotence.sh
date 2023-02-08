#!/bin/bash

SKDB_BIN=/skfs/build/skdb
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SERVER_DB=/tmp/server.db
LOCAL_DB=/tmp/local.db
UPDATES=/tmp/updates
WRITE_OUTPUT=/tmp/write-out

setup_server() {
    db=$SERVER_DB
    rm -f "$db" "$WRITE_OUTPUT"

    SKDB="$SKDB_BIN --data $db"
    $SKDB_BIN --init "$db"

    $SKDB < "$SCRIPT_DIR/privacy/init.sql"

    (echo "BEGIN TRANSACTION;";
     echo "INSERT INTO skdb_users VALUES(id('user'), 'test_user');"
     echo "COMMIT;"
    ) | $SKDB

    echo "CREATE TABLE test_with_pk (id INTEGER PRIMARY KEY, note STRING);" | $SKDB
    echo "CREATE TABLE test_without_pk (id INTEGER, note STRING);" | $SKDB
}

setup_local() {
    table=$1
    db=$LOCAL_DB
    rm -f "$db" "$UPDATES"

    SKDB="$SKDB_BIN --data $db"
    $SKDB_BIN --init "$db"

    echo "CREATE TABLE test_with_pk (id INTEGER PRIMARY KEY, note STRING);" | $SKDB
    echo "CREATE TABLE test_without_pk (id INTEGER, note STRING);" | $SKDB

    $SKDB_BIN subscribe --data $LOCAL_DB --connect --format=csv --updates $UPDATES "$table" > /dev/null
}

replicate_to_server() {
    table=$1
    $SKDB_BIN write-csv --data $SERVER_DB "$table" < $UPDATES > $WRITE_OUTPUT
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
    $SKDB_BIN --data $LOCAL_DB <<< "select * from test_without_pk;"

    echo server state:
    $SKDB_BIN --data $SERVER_DB <<< "select * from test_with_pk;"
    $SKDB_BIN --data $SERVER_DB <<< "select * from test_without_pk;"
    echo --------------------------------------
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
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" "$pattern" "$expected"
    rm -f "$output"
}


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

test_basic_replication_dup_rows() {
    setup_server
    setup_local test_without_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(1,'bar');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"

    output=$(mktemp)
    $SKDB_BIN --data $LOCAL_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 2
    assert_line_count "$output" bar 1
    rm -f "$output"

    replicate_to_server test_without_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 2
    assert_line_count "$output" bar 1
    rm -f "$output"
}

test_basic_replication_dup_rows_in_txn() {
    setup_server
    setup_local test_without_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(1,'bar');"
    (
        echo "BEGIN TRANSACTION;";
        echo "INSERT INTO test_without_pk VALUES(1,'bar');";
        echo "INSERT INTO test_without_pk VALUES(1,'bar');";
        echo "COMMIT;";
    ) | $SKDB_BIN --data $LOCAL_DB

    output=$(mktemp)
    $SKDB_BIN --data $LOCAL_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" bar 3
    rm -f "$output"

    replicate_to_server test_without_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" bar 3
    rm -f "$output"
}

test_basic_replication_dup_rows_replayed() {
    setup_server
    setup_local test_without_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(1,'bar');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"

    replicate_to_server test_without_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 2
    assert_line_count "$output" bar 1
    rm -f "$output"

    # simulate a reconnect - resend everything
    replicate_to_server test_without_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 2
    assert_line_count "$output" bar 1
    rm -f "$output"
}

test_basic_replication_dup_rows_server_state_different() {
    setup_server
    setup_local test_without_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"

    output=$(mktemp)
    $SKDB_BIN --data $LOCAL_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 2
    rm -f "$output"

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"

    replicate_to_server test_without_pk

    # last-writer-wins assignment semantic
    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 2
    rm -f "$output"
}

test_basic_replication_with_deletes() {
    setup_server
    setup_local test_without_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    replicate_to_server test_without_pk
    assert_server_rows_has 1 foo

    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_without_pk WHERE id = 0;"
    replicate_to_server test_without_pk
    assert_server_rows_has 0 foo

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_without_pk WHERE id = 0;"
    replicate_to_server test_without_pk
    assert_server_rows_has 0 foo

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_without_pk WHERE id = 0;"
    replicate_to_server test_without_pk
    assert_server_rows_has 0 foo

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_without_pk WHERE id = 0;"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    replicate_to_server test_without_pk
    assert_server_rows_has 1 foo
}

test_basic_replication_with_deletes_server_state_different() {
    setup_server
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"

    setup_local test_without_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "DELETE FROM test_without_pk WHERE id = 0;"
    replicate_to_server test_without_pk
    assert_server_rows_has 0 foo
}

test_replication_with_a_row_that_has_a_higher_than_two_repeat_count() {
    # quite a specific test. this is to ensure that write-csv can find
    # rows that have a repeat count other than 1 or 0.

    setup_server
    setup_local test_without_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"

    # ensure that the row is written to the server with a repeat of 2
    $SKDB_BIN write-csv --data $SERVER_DB "$table" > $WRITE_OUTPUT <<EOF


2	0,"foo"
EOF

    output=$(mktemp)
    $SKDB_BIN --data $LOCAL_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 2
    rm -f "$output"

    replicate_to_server test_without_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 1
    rm -f "$output"
}

test_replication_with_a_row_that_has_a_higher_than_two_repeat_count_dups() {
    # this time with multiple inserts

    setup_server
    setup_local test_without_pk

    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"
    $SKDB_BIN --data $LOCAL_DB <<< "INSERT INTO test_without_pk VALUES(0,'foo');"

    # ensure that the row is written to the server with a repeat of 2
    $SKDB_BIN write-csv --data $SERVER_DB "$table" > $WRITE_OUTPUT <<EOF


2	0,"foo"
EOF

    output=$(mktemp)
    $SKDB_BIN --data $LOCAL_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 3
    rm -f "$output"

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 2
    rm -f "$output"

    replicate_to_server test_without_pk

    output=$(mktemp)
    $SKDB_BIN --data $SERVER_DB <<< 'SELECT * FROM test_without_pk;' > "$output"
    assert_line_count "$output" foo 3
    rm -f "$output"
}

# tests:
run_test test_basic_replication_unique_rows
run_test test_basic_replication_unique_rows_replayed

run_test test_basic_replication_dup_rows
run_test test_basic_replication_dup_rows_in_txn
run_test test_basic_replication_dup_rows_replayed

run_test test_basic_replication_dup_rows_server_state_different

run_test test_basic_replication_with_deletes
run_test test_basic_replication_with_deletes_server_state_different

run_test test_replication_with_a_row_that_has_a_higher_than_two_repeat_count
run_test test_replication_with_a_row_that_has_a_higher_than_two_repeat_count_dups
