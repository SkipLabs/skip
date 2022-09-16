#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILE=$DIR/test.db
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
    echo "insert into skdb_groups values(id(), 'whitelist_group$i');" | $SKDB
done

for i in {1..10}; do
    echo "create table blacklist_group$i (userID integer);" | $SKDB
    echo "insert into blacklist_group$i select userID from skdb_users where userID % $i = 0;" | $SKDB
    echo "insert into skdb_groups values(-id(), 'blacklist_group$i');" | $SKDB
done

echo "create table posts (postID integer, skdb_privacy integer, skdb_owner integer, data string);" | $SKDB

GROUPID=`echo "select groupID from skdb_groups where readers = 'whitelist_group2';" | $SKDB`

echo "insert into posts values (id(), $GROUPID, 6, 'The first post!');" | $SKDB


cd ~/websockify && ./run 3048 -- /home/julienv/skfs/sql/server/start_tcp_server.sh
