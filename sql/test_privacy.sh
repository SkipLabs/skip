#!/bin/bash

rm -f /tmp/test.db

skdb --init /tmp/test.db
SKDB="skdb --data /tmp/test.db"

cat privacy/init.sql | $SKDB

echo "create table whitelist_group1 (userID INTEGER UNIQUE NOT NULL);" | $SKDB

GROUPID=`(
    echo "begin transaction;";
    echo "insert into skdb_groups values (id('whitelist_group1'), 'whitelist_group1', 1);";
    echo "select id('whitelist_group1');";
    echo "commit;";
) | $SKDB`

(echo "begin transaction;";
 for i in {1..1000}; do
     echo "insert into skdb_users values($i, 'user$i');"
 done;
 echo "commit;"
) | $SKDB

echo "create table test1 (id integer primary key, skdb_privacy integer, skdb_owner integer);" | $SKDB

(echo "begin transaction;";
 for i in {1..100}; do
     echo "insert into whitelist_group1 values($i);"
 done;
 echo "commit;"
) | $SKDB


(echo "begin transaction;";
 for i in {1..1000}; do
     echo "insert into test1 values($i, $GROUPID, $i);"
 done;
 echo "commit;"
) | $SKDB

