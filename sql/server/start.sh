#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILE=$DIR/test.db
SKDB_BIN=~/skfs/build/skdb
SKDB="$SKDB_BIN --data $FILE"

rm -f $FILE

$SKDB_BIN --init $FILE

cat ../privacy/init.sql | $SKDB

echo "create table whitelist_skiplabs_employees (userID INTEGER);"  | $SKDB

echo "insert into skdb_users values(id(), 'stranger');" | $SKDB

(echo "begin transaction;"
 echo "insert into skdb_users values(id('julienv'), 'julienv');" 
 echo "insert into skdb_users values(id('daniell'), 'daniell');" 
 echo "insert into skdb_users values(id('gregs'), 'gregs');" 
 echo "insert into skdb_users values(id('lucash'), 'lucash');"
 echo "insert into skdb_users values(id('laurem'), 'laurem');"

 echo "insert into whitelist_skiplabs_employees values(id('julienv'));" 
 echo "insert into whitelist_skiplabs_employees values(id('daniell'));" 
 echo "insert into whitelist_skiplabs_employees values(id('gregs'));" 
 echo "insert into whitelist_skiplabs_employees values(id('lucash'));"
 echo "insert into whitelist_skiplabs_employees values(id('laurem'));"
 echo "commit;"
) | $SKDB


GROUPID=`(
 echo "begin transaction;"
 echo "insert into skdb_groups values(id('group'), 'whitelist_skiplabs_employees');"
 echo "select id('group');"
 echo "commit;"
) | $SKDB`

echo "SKIPLABS EMPLOYEES: $GROUPID"
echo "JULIENV ID: " `echo "select userID from skdb_users where userName = 'julienv';" | $SKDB`

echo "create table posts (sessionID integer, localID integer, skdb_privacy integer, skdb_owner integer, data string);" | $SKDB



cd ~/websockify && ./run 3048 -- /home/julienv/skfs/sql/server/start_tcp_server.sh
