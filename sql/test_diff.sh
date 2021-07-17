#!/bin/bash

DB=/tmp/test.db
SQLIVE="../build/sqlive --data $DB"

run_diff () {


    rm -f /tmp/kk1 /tmp/kk2 $DB

    nviews=`cat $2 | grep VIEW | sed 's/CREATE VIEW V//' | sed 's/ .*//' | sort -n -r | head -n 1`

    ../build/sqlive --init $DB
    cat $1 $2 | $SQLIVE

    for i in $(seq 0 $((nviews))); do
        rm -f /tmp/V$i
        $SQLIVE --connect "V$i" --file "/tmp/V$i" > /dev/null &
    done


    cat $3 | $SQLIVE

    rm -f /tmp/selects.sql

    for i in $(seq 0 $((nviews))); do
        echo "select * from V$i;"
    done > /tmp/selects.sql;

    rm -f /tmp/replays

    for i in $(seq 0 $((nviews))); do
        cat "/tmp/V$i" | sqlive --replay >> /tmp/replays
    done;

    cat /tmp/selects.sql | $SQLIVE | sort -n > /tmp/kk1

    cat $2 | sed 's/CREATE VIEW V[0-9]* AS //' > /tmp/selects2.sql

    cat $1 $3 /tmp/selects2.sql | sqlite3 | sort -n > /tmp/kk2

    diff /tmp/kk1 /tmp/kk2 > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "$2 (part-1):\tOK"
    else
        echo -e "$2 (part-1):\tFAILED"
    fi

    cat /tmp/replays | sort -n > /tmp/kk2

    diff /tmp/kk1 /tmp/kk2 > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "$2 (part-2):\tOK"
    else
        echo -e "$2 (part-2):\tFAILED"
    fi

}

run_diff 'test/select1_float_create.sql' 'test/select1_float_views.sql' 'test/select1_float_inserts.sql'
run_diff 'test/select2_create.sql' 'test/select2_views.sql' 'test/select2_inserts.sql'
run_diff 'test/select3_create.sql' 'test/select3_views.sql' 'test/select3_inserts.sql'
run_diff 'test/select4.1-create.sql' 'test/select4.1-views.sql' 'test/select4.1-inserts.sql'
run_diff 'test/select5.1-create.sql' 'test/select5.1-views.sql' 'test/select5.1-inserts.sql'
run_diff 'test/limit-create.sql' 'test/limit-views.sql' 'test/limit-inserts.sql'
run_diff 'test/select1-limit-create.sql' 'test/select1-limit-views.sql' 'test/select1-limit-inserts.sql'
