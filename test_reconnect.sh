#!/bin/bash

rm -f /tmp/data

build/skdb --init /tmp/data

echo "create table t1 (a INTEGER);" | build/skdb --data /tmp/data
echo "create view v1 as select * from t1;" | build/skdb --data /tmp/data

for i in {1..100}; do echo "insert into t1 values($i);" | build/skdb --data /tmp/data; done

nc -l -p 2345 > /dev/null &

rm -f /tmp/out /tmp/err

build/skdb --data /tmp/data --connect /v1/ --cmd "nc -q 0 localhost 2345"

for i in {1..10}; do echo "insert into t1 values($i);" | build/skdb --data /tmp/data; done

nc -l -p 2345 > /tmp/server_out&

build/skdb --reconnect 210 --data /tmp/data

build/skdb --sessions --data /tmp/data
