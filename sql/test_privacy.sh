#!/bin/bash

rm -f /tmp/test.db

skdb --init /tmp/test.db

SKDB="skdb --data /tmp/test.db"

cat privacy/init.sql | $SKDB

echo "create table whitelist_group (userID INTEGER UNIQUE NOT NULL);" | $SKDB
echo "create table blacklist_group (userID INTEGER UNIQUE NOT NULL);" | $SKDB

GROUPID1=`(
    echo "begin transaction;";
    echo "insert into skdb_groups values (id('whitelist_group'), 'whitelist_group');";
    echo "select id('whitelist_group');";
    echo "commit;";
) | $SKDB`

GROUPID2=`(
    echo "begin transaction;";
    echo "insert into skdb_groups values (-id('blacklist_group'), 'blacklist_group');";
    echo "select id('blacklist_group');";
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
     echo "insert into whitelist_group values($i);"
 done;
 echo "commit;"
) | $SKDB


(echo "begin transaction;";
 for i in {1..500}; do
     echo "insert into test1 values($i, $GROUPID1, $i);"
 done;
 echo "commit;"
) | $SKDB

(echo "begin transaction;";
 for i in {501..1000}; do
     echo "insert into test1 values($i, $GROUPID2, $i);"
 done;
 echo "commit;"
) | $SKDB

