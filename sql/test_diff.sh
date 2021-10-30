#!/bin/bash

DB=/tmp/test.db
SQLIVE="../build/sqlive --always-allow-joins --data $DB"

run_diff () {


    rm -f /tmp/kk1 /tmp/kk2 /tmp/kk3 $DB

    nviews=`cat $2 | grep VIEW | sed 's/CREATE VIRTUAL VIEW V//' | sed 's/ .*//' | sort -n -r | head -n 1`

    ../build/sqlive --init $DB
    cat $1 $2 | $SQLIVE

    for i in $(seq 0 $((nviews))); do
        rm -f /tmp/V$i
        $SQLIVE --connect "V$i" --stream "/tmp/V$i" > /dev/null &
    done


    cat $3 $4 $5 | $SQLIVE

    rm -f /tmp/selects.sql

    for i in $(seq 0 $((nviews))); do
        echo "select * from V$i;"
    done > /tmp/selects.sql;

    rm -f /tmp/replays

    for i in $(seq 0 $((nviews))); do
        cat "/tmp/V$i" | sqlive --replay >> /tmp/replays
    done;

    cat /tmp/selects.sql | $SQLIVE | sort -n > /tmp/kk1

    cat $2 | sed 's/CREATE VIRTUAL VIEW V[0-9]* AS //' > /tmp/selects2.sql

    cat $1 $3 $4 $5 /tmp/selects2.sql > /tmp/foo
    cat $1 $3 $4 $5 /tmp/selects2.sql | sqlite3 | sort -n > /tmp/kk2

    diff /tmp/kk1 /tmp/kk2
    diff /tmp/kk1 /tmp/kk2 > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "$2 (part-1):\tOK"
    else
        echo -e "$2 (part-1):\tFAILED"
    fi

    cat /tmp/replays | sort -n > /tmp/kk3

    diff /tmp/kk1 /tmp/kk3 > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "$2 (part-2):\tOK"
    else
        echo -e "$2 (part-2):\tFAILED"
    fi

}

run_diff 'test/select2_create.sql' 'test/select2_min_views.sql' 'test/select2_inserts.sql'
run_diff 'test/select2_create.sql' 'test/select2_min_views.sql' 'test/select2_inserts.sql' 'test/select2_deletes.sql'
run_diff 'test/select2_create.sql' 'test/select2_min_views.sql' 'test/select2_inserts.sql' 'test/select2_deletes.sql' 'test/select2_inserts.sql'
run_diff 'test/select1_float_create.sql' 'test/select1_float_views.sql' 'test/select1_float_inserts.sql'
run_diff 'test/select2_create.sql' 'test/select2_views.sql' 'test/select2_inserts.sql'
run_diff 'test/select3_create.sql' 'test/select3_views.sql' 'test/select3_inserts.sql'
run_diff 'test/select3_create.sql' 'test/select3_views.sql' 'test/select3_inserts.sql' 'test/select3_partial_delete.sql'
run_diff 'test/select4.1-create.sql' 'test/select4.1-views.sql' 'test/select4.1-inserts.sql'
run_diff 'test/select5.1-create.sql' 'test/select5.1-views.sql' 'test/select5.1-inserts.sql'
run_diff 'test/groupby_create.sql' 'test/groupby_views.sql' 'test/groupby_inserts.sql'
run_diff 'test/groupby_create.sql' 'test/groupby_views.sql' 'test/groupby_inserts.sql' 'test/groupby_delete.sql'
run_diff 'test/slt_good_0_create.sql' 'test/slt_good_0_views.sql' 'test/slt_good_0_inserts.sql'
