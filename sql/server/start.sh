#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILE=$DIR/test.db
SKDB_BIN=~/skfs/build/skdb
SKDB="$SKDB_BIN --data $FILE"

rm -f $FILE

$SKDB_BIN --init $FILE

cat ../privacy/init.sql | $SKDB

echo "create table skiplabs_employees (userID INTEGER);"  | $SKDB

echo "insert into skdb_user values(id(), 'stranger');" | $SKDB

(echo "begin transaction;"
 echo "insert into skdb_users values(id('julienv'), 'julienv');" 
 echo "insert into skdb_users values(id('daniell'), 'daniell');" 
 echo "insert into skdb_users values(id('gregs'), 'gregs');" 
 echo "insert into skdb_users values(id('lucash'), 'lucash');"
 echo "insert into skdb_users values(id('laurem'), 'laurem');"

 echo "insert into skiplabs_employees values(id('julienv'));" 
 echo "insert into skiplabs_employees values(id('daniell'));" 
 echo "insert into skiplabs_employees values(id('gregs'));" 
 echo "insert into skiplabs_employees values(id('lucash')');"
 echo "insert into skiplabs_employees values(id('laurem')');"
 echo "commit;"
) | $SKDB




echo "create table posts (sessionID integer, localID integer, skdb_privacy integer, skdb_owner integer, data string);" | $SKDB



cd ~/websockify && ./run 3048 -- /home/julienv/skfs/sql/server/start_tcp_server.sh
