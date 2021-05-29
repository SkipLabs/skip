#!/bin/bash

rm -f /tmp/data

build/sqlive --init /tmp/data

echo "create table t1 (a INTEGER);" | build/sqlive --data /tmp/data
echo "create view v1 as select * from t1;" | build/sqlive --data /tmp/data

for i in {1..100}; do echo "insert into t1 values($i);" | build/sqlive --data /tmp/data; done

nc -l -p 2345 > /dev/null &

rm -f /tmp/out /tmp/err

build/sqlive --data /tmp/data --connect /v1/ --cmd "nc -q 0 localhost 2345"

for i in {1..10}; do echo "insert into t1 values($i);" | build/sqlive --data /tmp/data; done

nc -l -p 2345 > /tmp/server_out&

build/sqlive --reconnect 624 --data /tmp/data

build/sqlive --sessions --data /tmp/data
