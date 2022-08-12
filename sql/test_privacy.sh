#!/bin/bash

rm -f /tmp/test.db

skdb --init /tmp/test.db
SKDB="skdb --data /tmp/test.db"

cat privacy/init.sql | $SKDB
GROUPID=`cat init_test_privacy.sql | $SKDB`

(echo "begin transaction;";
 for i in {1..10000}; do
     echo "insert into skdb_users values($i, 'user$i');"
 done;
 echo "commit;"
) | skdb --data /tmp/test.db


(echo "begin transaction;";
 for i in {1..100000}; do
     echo "insert into skdb_arrows values($i, $i, $GROUPID);"
 done;
 echo "commit;"
) | skdb --data /tmp/test.db

(echo "begin transaction;";
 for i in {1..10000}; do
     echo "insert into groupID1_readers values($i);"
 done;
 echo "commit;"
) | skdb --data /tmp/test.db


