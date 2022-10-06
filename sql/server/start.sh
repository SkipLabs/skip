#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILE=$DIR/test.db
SKDB_BIN=~/skfs/build/skdb
SKDB="$SKDB_BIN --data $FILE"

rm -f $FILE

$SKDB_BIN --init $FILE

cat ../privacy/init.sql | $SKDB

echo "insert into skdb_users values(id(), 'julienv');" | $SKDB
echo "insert into skdb_users values(id(), 'daniell');" | $SKDB
echo "insert into skdb_users values(id(), 'gregs');" | $SKDB
echo "insert into skdb_users values(id(), 'lucash');" | $SKDB
echo "insert into skdb_users values(id(), 'laurem');" | $SKDB

echo "create virtual view all_users as select userID, userName, null as skdb_privacy from skdb_users;" | $SKDB
echo "create table all_admin_groups (groupID INTEGER, groupName TEXT, skdb_privacy INTEGER);" | $SKDB

echo "create table whitelist_skiplabs_employees_admins (userID INTEGER);" | $SKDB
ADMINS_ID=`(
 echo "begin transaction;"
 echo "insert into skdb_groups values(id('admin'), 'whitelist_skiplabs_employees_admins');"
 echo "insert into all_admin_groups values(id('admin'), 'whitelist_skiplabs_employees_admins', null);"
 echo "insert into whitelist_skiplabs_employees_admins select userID from skdb_users where userName = 'julienv';"
 echo "select id('admin');"
 echo "commit;"
) | $SKDB`

echo "create table whitelist_skiplabs_employees (userID INTEGER, skdb_privacy INTEGER, skdb_owner INTEGER);"  | $SKDB

echo "insert into skdb_users values(id(), 'stranger');" | $SKDB

JULIENID=`echo "select userID from skdb_users where userName = 'julienv';" | $SKDB`

echo "insert into whitelist_skiplabs_employees select userID, $ADMINS_ID, $JULIENID from all_users where userName = 'julienv';" | $SKDB --user julienv
echo "insert into whitelist_skiplabs_employees select userID, $ADMINS_ID, $JULIENID from all_users where userName = 'daniell';" | $SKDB --user julienv
echo "insert into whitelist_skiplabs_employees select userID, $ADMINS_ID, $JULIENID from all_users where userName = 'gregs';" | $SKDB --user julienv
echo "insert into whitelist_skiplabs_employees select userID, $ADMINS_ID, $JULIENID from all_users where userName = 'lucash';" | $SKDB --user julienv
echo "insert into whitelist_skiplabs_employees select userID, $ADMINS_ID, $JULIENID from all_users where userName = 'laurem';" | $SKDB --user julienv

GROUPID=`(
 echo "begin transaction;"
 echo "insert into skdb_groups values(id('group'), 'whitelist_skiplabs_employees');"
 echo "select id('group');"
 echo "commit;"
) | $SKDB`

STRANGERID=`echo "select userID from skdb_users where userName = 'stranger';" | $SKDB`

echo "SKIPLABS EMPLOYEES: $GROUPID"
echo "JULIENV ID: $JULIENID"
echo "STRANGER ID: $STRANGERID"
echo "GROUP ID: $GROUPID"

echo "create table posts (sessionID integer, localID integer, skdb_privacy integer, skdb_owner integer, data string);" | $SKDB
echo "insert into posts values(22, 23, $GROUPID, $JULIENID, 'my first post');" | $SKDB


cd ~/websockify && ./run 3048 --wrap-mode=respawn -v  -- /home/julienv/skfs/sql/server/start_tcp_server.sh
