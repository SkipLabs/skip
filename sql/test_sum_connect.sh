#!/bin/bash

SQLIVE=../build/sqlive
DB=/tmp/test.db

rm -f /tmp/foo $DB

$SQLIVE --init $DB
echo "create table t1 (a INTEGER); insert into t1 values(22); create view v1 as select sum(a) from t1;" | $SQLIVE --data $DB

for i in {1..1}; do
    rm -f "/tmp/foo$i"
    $SQLIVE --connect v1 --data $DB --file "/tmp/foo$i"
done

for j in {1..10}; do
    (echo "begin transaction;"; for i in {1..10000}; do echo "insert into t1 values($i);"; done; echo "commit;"; ) | $SQLIVE --data $DB &
done;
wait
