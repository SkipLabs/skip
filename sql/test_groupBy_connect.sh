#!/bin/bash

SQLIVE=../build/sqlive
DB=/tmp/test.db

rm -f /tmp/foo $DB

$SQLIVE --init $DB
echo "create table t2 (a INTEGER, b INTEGER); create view v1 as select a%4, sum(b) from t2 group by 1;" | $SQLIVE --data $DB

for i in {1..1}; do
    rm -f "/tmp/foo$i"
    $SQLIVE --connect v1 --data $DB --file "/tmp/foo$i"
done

for j in {1..10}; do
    (for i in {1..100}; do echo "insert into t2 values($i, $i);"; done;) | $SQLIVE --data $DB &
done;
wait

echo "select * from v1;" | $SQLIVE --data $DB
