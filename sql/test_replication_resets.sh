#!/bin/bash

SKDB_BIN=./target/skdb

SERVER_DB=/tmp/server.db
SERVER_TAIL=/tmp/server_tail

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
    echo "CREATE TABLE test_with_pk (id INTEGER PRIMARY KEY, note STRING);" | $SKDB
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
    # sanity check the tick value - it's important for later - we're at 48 they're at 10
    assert_line_count "$SERVER_TAIL" ':48 10' 1

    # now the source under test sends up a reset for whatever reason -
    # maybe reconnect. it wipes out its own foo value but not the new,
    # because it hasn't seen this row yet: 35 < 48.
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
    assert_line_count "$SERVER_TAIL" ':50' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL

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
    assert_line_count "$SERVER_TAIL" ':50' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test > /dev/null << EOF


1	1,"bar"
1	2,"baz"
1	3,"quux"
		
:10 50
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL

    # just one of each.
    assert_line_count "$SERVER_TAIL" '0\|foo' 0
    assert_line_count "$SERVER_TAIL" '1\|bar' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
    assert_line_count "$SERVER_TAIL" '3\|quux' 1
}

run_test test_resets_are_aggressively_nooped_but_we_do_not_lose_an_update

# same as above but the contributions are reversed to demonstrate that adds win over deletes
test_resets_are_aggressively_nooped_but_we_do_not_lose_an_update2() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':50' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test > /dev/null << EOF


1	1,"bar"
1	2,"baz"
1	3,"quux"
		
:10 50
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL

    # just one of each. foo is still here as it was added concurrently and adds beat deletes
    assert_line_count "$SERVER_TAIL" '0\|foo' 1
    assert_line_count "$SERVER_TAIL" '1\|bar' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
    assert_line_count "$SERVER_TAIL" '3\|quux' 1
}

run_test test_resets_are_aggressively_nooped_but_we_do_not_lose_an_update2

# test the no-op logic gets to correct repeat counts
test_resets_no_op_repeat_count_logic() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (2,'baz');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (2,'baz');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':68' 1

    # this is added concurrently and shouldn't be eligible
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (2,'baz');"

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test > /dev/null << EOF


7	0,"foo"
0	1,"bar"
2	2,"baz"
		
:10 68
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL

    assert_line_count "$SERVER_TAIL" '0\|foo' 7
    assert_line_count "$SERVER_TAIL" '1\|bar' 0
    assert_line_count "$SERVER_TAIL" '2\|baz' 3

    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':77' 1

    # this is added concurrently and shouldn't be eligible
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test VALUES (2,'baz');"

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test > /dev/null << EOF


5	0,"foo"
1	1,"bar"
2	2,"baz"
		
:20 77
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test" > $SERVER_TAIL

    assert_line_count "$SERVER_TAIL" '0\|foo' 5
    assert_line_count "$SERVER_TAIL" '1\|bar' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 3
}

run_test test_resets_no_op_repeat_count_logic


################################################################################
# concurrency tests against a table with a PK
################################################################################

# if a client sends up a reset it should not wipe out local writes that haven't sync'd
test_server_should_apply_client_reset_only_to_writes_seen_pk() {
    setup_server

    # write a row as the source under test
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test_with_pk > /dev/null << EOF


1	0,"foo"
:10
EOF

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES(7,'new');"
    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test_with_pk)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL

    # if we did replicate now we would get the new row
    assert_line_count "$SERVER_TAIL" 'new' 1
    # sanity check the tick value - it's important for later - we're at 48 they're at 10
    assert_line_count "$SERVER_TAIL" ':48 10' 1

    # now the source under test sends up a reset for whatever reason -
    # maybe reconnect. it wipes out its own foo value but not the new,
    # because it hasn't seen this row yet: 35 < 48.
    $SKDB_BIN write-csv --data $SERVER_DB --source 1234 --user test_user test_with_pk > /dev/null << EOF


1	1,"baz"
1	2,"quux"
		
:22 35
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test_with_pk" > $SERVER_TAIL

    assert_line_count "$SERVER_TAIL" '1\|baz' 1
    assert_line_count "$SERVER_TAIL" '2\|quux' 1
    assert_line_count "$SERVER_TAIL" '0\|foo' 0
    assert_line_count "$SERVER_TAIL" '7\|new' 1
}

run_test test_server_should_apply_client_reset_only_to_writes_seen_pk

# if two clients reconnect concurrently (due to e.g. server crash)
# they may send up concurrent resets and duplicate the world. ensure
# this doesn't happen
test_resets_are_aggressively_nooped_pk() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test_with_pk)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':50' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test_with_pk > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test_with_pk > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test_with_pk" > $SERVER_TAIL

    # just one of each
    assert_line_count "$SERVER_TAIL" '0\|foo' 1
    assert_line_count "$SERVER_TAIL" '1\|bar' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
}

run_test test_resets_are_aggressively_nooped_pk

# same as above but one of the clients is contributing a change
test_resets_are_aggressively_nooped_with_local_change_pk() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test_with_pk)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':50' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test_with_pk > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test_with_pk > /dev/null << EOF


1	1,"bar"
1	2,"baz"
1	3,"quux"
		
:10 50
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test_with_pk" > $SERVER_TAIL

    # just one of each.
    assert_line_count "$SERVER_TAIL" '0\|foo' 1
    assert_line_count "$SERVER_TAIL" '1\|bar' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
    assert_line_count "$SERVER_TAIL" '3\|quux' 1
}

run_test test_resets_are_aggressively_nooped_with_local_change_pk

# same as above but the contributions are reversed to demonstrate that adds win over deletes
test_resets_are_aggressively_nooped_with_local_change_pk_2() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test_with_pk)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':50' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test_with_pk > /dev/null << EOF


1	1,"bar"
1	2,"baz"
1	3,"quux"
		
:10 50
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test_with_pk > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test_with_pk" > $SERVER_TAIL

    # just one of each. foo is still here as it was added concurrently and adds beat deletes
    assert_line_count "$SERVER_TAIL" '0\|foo' 1
    assert_line_count "$SERVER_TAIL" '1\|bar' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
    assert_line_count "$SERVER_TAIL" '3\|quux' 1
}

run_test test_resets_are_aggressively_nooped_with_local_change_pk_2

# now with a conflict, two clients trying to modify the same row
test_resets_conflicting_pk() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test_with_pk)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':50' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test_with_pk > /dev/null << EOF


1	1,"win"
1	2,"baz"
1	3,"quux"
		
:10 50
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test_with_pk > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test_with_pk" > $SERVER_TAIL

    # just one of each. foo is still here as it was added concurrently and adds beat deletes
    assert_line_count "$SERVER_TAIL" '0\|foo' 1
    assert_line_count "$SERVER_TAIL" '1\|bar' 0
    assert_line_count "$SERVER_TAIL" '1\|win' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
    assert_line_count "$SERVER_TAIL" '3\|quux' 1
}

run_test test_resets_conflicting_pk

test_resets_conflicting_reversed_pk() {
    setup_server

    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (0,'foo');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (1,'bar');"
    $SKDB_BIN --data $SERVER_DB <<< "INSERT INTO test_with_pk VALUES (2,'baz');"

    server_session=$($SKDB_BIN subscribe --data $SERVER_DB --connect --user test_user --ignore-source 1234 test_with_pk)
    $SKDB_BIN tail --data $SERVER_DB --format=csv "$server_session" --since 0 > $SERVER_TAIL
    # we need to check the server tick so that the values provided in below resets are accurate
    assert_line_count "$SERVER_TAIL" ':50' 1

    # server crashes and two clients that are up to speed reconnect with resets

    $SKDB_BIN write-csv --data $SERVER_DB --source 1 --user test_user test_with_pk > /dev/null << EOF


1	0,"foo"
1	1,"bar"
1	2,"baz"
		
:10 50
EOF

    $SKDB_BIN write-csv --data $SERVER_DB --source 2 --user test_user test_with_pk > /dev/null << EOF


1	1,"win"
1	2,"baz"
1	3,"quux"
		
:10 50
EOF

    $SKDB_BIN --data $SERVER_DB <<< "SELECT * FROM test_with_pk" > $SERVER_TAIL

    # just one of each. foo is still here as it was added concurrently and adds beat deletes
    assert_line_count "$SERVER_TAIL" '0\|foo' 1
    assert_line_count "$SERVER_TAIL" '1\|bar' 0
    assert_line_count "$SERVER_TAIL" '1\|win' 1
    assert_line_count "$SERVER_TAIL" '2\|baz' 1
    assert_line_count "$SERVER_TAIL" '3\|quux' 1
}

run_test test_resets_conflicting_reversed_pk
