#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILE=$DIR/test.db
SKDB_BIN=~/skfs/build/skdb
SKDB="$SKDB_BIN --data $FILE"

rm -f $FILE

$SKDB_BIN --init $FILE

cat ../privacy/init.sql | $SKDB

echo "insert into skdb_users values(id(), 'julienv');"
echo "insert into skdb_users values(id(), 'daniell');"
echo "insert into skdb_users values(id(), 'gregs');"
echo "insert into skdb_users values(id(), 'lucash');"
echo "insert into skdb_users values(id(), 'laurem');"

echo "create table posts (sessionID integer, localID integer, skdb_privacy integer, skdb_owner integer, data string);" | $SKDB

GROUPID=`echo "select groupID from skdb_groups where readers = 'whitelist_group2';" | $SKDB`

echo "insert into posts values (id(), id(), $GROUPID, 6, 'The first post!');" | $SKDB


cd ~/websockify && ./run 3048 -- /home/julienv/skfs/sql/server/start_tcp_server.sh
