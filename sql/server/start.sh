#!/bin/bash

FILE=/tmp/test.db
SKDB_BIN=~/skfs/build/skdb
SKDB="$SKDB_BIN --data $FILE"

rm -f $FILE

$SKDB_BIN --init $FILE

cat ../privacy/init.sql | $SKDB

(echo "begin transaction;"
 for i in {1..10}; do
     echo "insert into skdb_users values($i, 'user$i');"
 done
 echo "commit;") | $SKDB

for i in {1..10}; do
    echo "create table whitelist_group$i (userID integer);" | $SKDB
    echo "insert into whitelist_group$i select userID from skdb_users where userID % $i = 0;" | $SKDB
done

for i in {1..10}; do
    echo "create table blacklist_group$i (userID integer);" | $SKDB
    echo "insert into blacklist_group$i select userID from skdb_users where userID % $i = 0;" | $SKDB
done

cd ~/websockify && ./run 3048 -- /home/julienv/skfs/sql/server/start_tcp_server.sh
