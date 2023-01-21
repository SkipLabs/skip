#!/bin/bash

DB=/tmp/test.db
SKDB="./target/skdb --always-allow-joins --data $DB"

rm -f /tmp/test.db
./target/skdb --init /tmp/test.db

cat 'test/select2_create_window.sql' | $SKDB

echo "CREATE VIRTUAL VIEW V1000 AS SELECT sum(c) FROM t1;" | $SKDB

cat 'test/select2_inserts_window.sql' | $SKDB

if echo "select * from V1000;" | $SKDB | grep -q '4939'
then
    echo -e "Window sum:\tOK"
else
    echo -e "Window sum:\tFAILED"
fi

echo "INSERT INTO t1 VALUES(30,248,10,249,245);" | $SKDB

if echo "select * from V1000;" | $SKDB | grep -q '4949'
then
    echo -e "Window sum2:\tOK"
else
    echo -e "Window sum2:\tFAILED"
fi

echo "INSERT INTO t1 VALUES(31,248,10,249,245);" | $SKDB

if echo "select * from V1000;" | $SKDB | grep -q '4851'
then
    echo -e "Window sum3:\tOK"
else
    echo -e "Window sum3:\tFAILED"
fi

size1=0
size2=0

for i in {32..60}; do
    echo "INSERT INTO t1 VALUES($i,248,10,249,245);" | $SKDB
    size1=`$SKDB --size`
done

for i in {61..100}; do
    echo "INSERT INTO t1 VALUES($i,248,10,249,245);" | $SKDB
    size2=`$SKDB --size`
done

if [ "$size1" -eq "$size2" ]; then
    echo -e "Window size stabilized:\tOK"
else
    echo -e "Window size stabilized:\tFAILED"
fi
