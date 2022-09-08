#!/bin/bash

rm -f /tmp/test.db

skdb --init /tmp/test.db
SKDB="skdb --data /tmp/test.db"

cat privacy/init.sql | $SKDB
GROUPID=`cat init_test_privacy.sql | $SKDB`

(echo "begin transaction;";
 for i in {1..1000}; do
     echo "insert into skdb_users values($i, 'user$i');"
 done;
 echo "commit;"
) | skdb --data /tmp/test.db


(echo "begin transaction;";
 for i in {1..1000}; do
     echo "insert into skdb_arrows values($i, $i, $GROUPID);"
 done;
 echo "commit;"
) | skdb --data /tmp/test.db

(echo "begin transaction;";
 for i in {1..100}; do
     echo "insert into groupID1_readers values($i);"
 done;
 echo "commit;"
) | skdb --data /tmp/test.db


(echo "begin transaction;";
 echo "insert into skdb_objects values (id('obj1'), 'test_table', 22, NULL);";
 echo "insert into skdb_objects values (id('obj2'), 'test_table', 23, NULL);";
 echo "insert into skdb_arrows values (id('obj1'), id('obj2'), NULL);";
 echo "insert into skdb_roots values (id('root'), id('obj1'), 3, 3, NULL);";
 echo "select id('root');";
 echo "commit;") | $SKDB

