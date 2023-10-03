#!/bin/bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

DBFILE=/tmp/test.db

rm -f $DBFILE

if [ -z "$SKARGO_PROFILE" ]; then
    SKARGO_PROFILE=dev
fi

SKDB_CMD="skargo run --profile $SKARGO_PROFILE -- "

$SKDB_CMD --init $DBFILE

SKDB="$SKDB_CMD --data $DBFILE"

cat privacy/init.sql | $SKDB

echo "create table t1 (id INTEGER primary key, skdb_group STRING);" | $SKDB
subt1=`$SKDB subscribe t1`

echo "create table t2 (id INTEGER primary key);" | $SKDB
echo "create table t3 (id INTEGER primary key, skdb_group STRING);" | $SKDB
echo "create virtual view v1 as select id, id as skdb_group from t1 ;" | $SKDB

###############################################################################
# Creating the users
###############################################################################

for i in {1..10}; do
    echo "insert into skdb_users values('ID$i', 'pass');"
done | $SKDB

###############################################################################
# TABLE PERMISSIONS
###############################################################################

# Checking that if a table is readonly, the user cannot write
echo "insert into skdb_table_permissions values ('t2', 4);" | $SKDB

if echo -e "1\t234" | $SKDB write-csv t2 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST TABLE PERMISSIONS:\tOK"
else 
    echo -e "TEST TABLE PERMISSIONS:\tFAILED"
fi

# Let's change the permissions and see if we can write now
echo "update skdb_table_permissions set permissions=6 where name='t2';" | $SKDB

if echo -e "1\t234" | $SKDB write-csv t2 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST TABLE PERMISSIONS2:\tFAILED"
else 
    echo -e "TEST TABLE PERMISSIONS2:\tOK"
fi

# Let's make sure we cannot delete
if echo -e "0\t234" | $SKDB write-csv t2 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST TABLE PERMISSIONS3:\tOK"
else 
    echo -e "TEST TABLE PERMISSIONS3:\tFAILED"
fi

###############################################################################
# USER PERMISSIONS
###############################################################################

# Let's check that user permissions are respected
# This should turn every user into "readonly"
echo "insert into skdb_user_permissions values (NULL, 4);" | $SKDB

if echo -e "1\t235" | $SKDB write-csv t2 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST USER PERMISSIONS:\tOK"
else
    echo -e "TEST USER PERMISSIONS:\tFAILED"
fi

# Let's check that user permissions are respected for a specific user
echo "insert into skdb_user_permissions values ('ID1', 6);" | $SKDB

if echo -e "1\t235" | $SKDB write-csv t2 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST USER PERMISSIONS2:\tFAILED"
else
    echo -e "TEST USER PERMISSIONS2:\tOK"
fi

###############################################################################
# GROUP PERMISSIONS
###############################################################################

# Let's create a group
# user1 can write, all the others can only read
echo "insert into skdb_group_permissions values ('ID22', 'ID1', 7);" | $SKDB
echo "insert into skdb_group_permissions values ('ID22', 'ID2', 4);" | $SKDB
echo "insert into skdb_group_permissions values ('ID22', 'ID3', 4);" | $SKDB

# Let's check user1 can write
if echo -e "1\t238,\"ID22\"" | $SKDB write-csv t1 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST GROUP PERMISSIONS:\tFAILED"
else
    echo -e "TEST GROUP PERMISSIONS:\tOK"
fi

# Let's check user2 cannot write
if echo -e "1\t239,\"ID22\"" | $SKDB write-csv t1 --user ID2 2>&1 | grep -q Error; then
    echo -e "TEST GROUP PERMISSIONS2:\tOK"
else
    echo -e "TEST GROUP PERMISSIONS2:\tFAILED"
fi

# Let's check user3 cannot write
if echo -e "1\t239,\"ID22\"" | $SKDB write-csv t1 --user ID3 2>&1 | grep -q Error; then
    echo -e "TEST GROUP PERMISSIONS3:\tOK"
else
    echo -e "TEST GROUP PERMISSIONS3:\tFAILED"
fi

# Let's check that user2 can read
if $SKDB tail $subt1 --user ID2 2>&1 | grep -q "238|\"ID22\""; then
    echo -e "TEST GROUP PERMISSIONS4:\tOK"
else
    echo -e "TEST GROUP PERMISSIONS4:\tFAILED"
fi

# Let's change the table permissions and see what happens
echo "insert into skdb_table_permissions values (NULL, 0)" | $SKDB

# Let's check that user2 cannot read
if $SKDB tail $subt1 --user ID2 2>&1 | grep -q "238|\"ID22\""; then
    echo -e "TEST GROUP PERMISSIONS5:\tFAILED"
else
    echo -e "TEST GROUP PERMISSIONS5:\tOK"
fi

echo "delete from skdb_table_permissions;" | $SKDB

# Let's change the user permissions and see what happens
echo "insert into skdb_user_permissions values ('ID2', 0)" | $SKDB

# Let's check that user2 cannot read
if $SKDB tail $subt1 --user ID2 2>&1 | grep -q "238|\"ID22\""; then
    echo -e "TEST GROUP PERMISSIONS6:\tFAILED"
else
    echo -e "TEST GROUP PERMISSIONS6:\tOK"
fi

echo "delete from skdb_user_permissions where userName='ID2';" | $SKDB

# Let's check that user2 can read again
if $SKDB tail $subt1 --user ID2 2>&1 | grep -q "238|\"ID22\""; then
    echo -e "TEST GROUP PERMISSIONS7:\tOK"
else
    echo -e "TEST GROUP PERMISSIONS7:\tFAILED"
fi

# Let's kick user2 out of the group
echo "delete from skdb_group_permissions where groupName='ID22' and userName='ID2';" | $SKDB

# Let's check that user2 cannot read (after being kicked out)
if $SKDB tail $subt1 --user ID2 2>&1 | grep -q "238|\"ID22\""; then
    echo -e "TEST GROUP PERMISSIONS8:\tFAILED"
else
    echo -e "TEST GROUP PERMISSIONS8:\tOK"
fi

###############################################################################
# BLOCKLIST PERMISSIONS
###############################################################################

# Let's create a block list
# Everybody can read/insert/delete, except for user1 who can only read
echo "insert into skdb_group_permissions values ('ID23', 'ID1', 4);" | $SKDB
echo "insert into skdb_group_permissions values ('ID23', NULL, 7);" | $SKDB

# Let's check user2 can write
if echo -e "1\t240,\"ID23\"" | $SKDB write-csv t1 --user ID2 2>&1 | grep -q Error; then
    echo -e "TEST GROUP PERMISSIONS9:\tFAILED"
else
    echo -e "TEST GROUP PERMISSIONS9:\tOK"
fi

# Let's check user1 cannot write
if echo -e "1\t241,\"ID23\"" | $SKDB write-csv t1 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST GROUP PERMISSIONS10:\tOK"
else
    echo -e "TEST GROUP PERMISSIONS10:\tFAILED"
fi

# Let's check that user1 can read
if $SKDB tail $subt1 --user ID1 2>&1 | grep -q "240|\"ID23\""; then
    echo -e "TEST GROUP PERMISSIONS11:\tOK"
else
    echo -e "TEST GROUP PERMISSIONS11:\tFAILED"
fi

###############################################################################
# SKDB_AUTHOR CHECK
###############################################################################

echo "create table t4 (id INTEGER, skdb_author STRING);" | $SKDB
if echo -e "1\t240,\"ID23\"" | $SKDB write-csv t4 --user ID3 2>&1 | grep -q Error
then echo -e "TEST AUTHOR:\tOK"
else echo -e "TEST AUTHOR:\tFAILED"
fi
if echo -e "1\t240,\"ID3\"" | $SKDB write-csv t4 --user ID3 2>&1 | grep -q Error
then echo -e "TEST AUTHOR2:\tOK"
else echo -e "TEST AUTHOR2:\tFAILED"
fi

###############################################################################
# PERMISSION CHANGES WHILE TAILING
###############################################################################

tail -f /dev/null |
  $SKDB tail $subt1 --format=csv --user ID3 --follow |
  $SKDB write-csv t3 > /dev/null &

tailerID=$!

# Just leaving enough time for the tailer to fill up with data. The
# test is less interesting if it doesn't.

sleep 1

# let's kick ID3 out of the group 22
echo "delete from skdb_group_permissions where groupName='ID22' and userName='ID3';" | $SKDB

# As long as the row (238,22) is still there, the update did not kick in
while echo "select * from t3" | $SKDB | grep -q "238"; do
    sleep 1
done

# The reset was successful
echo -e "TEST GROUP PERMISSION UPDATE:\tOK"

# let's block the ID3 all together
echo "insert into skdb_user_permissions values('ID3', 0);" | $SKDB

# As long as the row (240,22) is still there, the update did not kick in
while echo "select * from t3" | $SKDB | grep -q "240"; do
    echo "select * from t3" | $SKDB | grep -q "240"
    sleep 1
done

# The reset was successful
echo -e "TEST GROUP PERMISSION UPDATE2:\tOK"

# let's reset all the permissions and make sure all the data is back

# let's kick ID3 out of the group 22
(echo "begin transaction;";
 echo "insert into skdb_group_permissions values('ID22', 'ID3', 7);";
 echo "delete from skdb_user_permissions where userName='ID3';"
 echo "commit;"
)| $SKDB

sleep 1

echo "select * from t3" | $SKDB

# wait for the data to arrive
until echo "select * from t3" | $SKDB | grep -q "240"; do
    sleep 1
done

until echo "select * from t3" | $SKDB | grep -q "238"; do
    sleep 1
done

# The reset was successful
echo -e "TEST GROUP PERMISSION UPDATE3:\tOK"

# Finally, let's block that table

echo "insert into skdb_table_permissions values ('t1', 0);" | $SKDB

sleep 1

# Let's wait for the data to be removed
while echo "select * from t3" | $SKDB | grep -q "240"; do
    sleep 1
done
while echo "select * from t3" | $SKDB | grep -q "238"; do
    sleep 1
done

echo -e "TEST GROUP PERMISSION UPDATE4:\tOK"

