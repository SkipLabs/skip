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

echo "create table t1 (id INTEGER primary key, skdb_access STRING);" | $SKDB
subt1=`$SKDB subscribe t1`

echo "create table t2 (id INTEGER primary key, skdb_access STRING);" | $SKDB
echo "create table t3 (id INTEGER primary key, skdb_access STRING);" | $SKDB
echo "create virtual view v1 as select id, id as skdb_access from t1 ;" | $SKDB

###############################################################################
# Creating the users
###############################################################################

for i in {1..10}; do
    echo "insert into skdb_users values('ID$i', 'pass');"
done | $SKDB

###############################################################################
# USER PERMISSIONS
###############################################################################

# We need a group that doesn't restrict anyone.
echo "insert into skdb_groups values('myGroup', NULL, 'root', 'root');" | $SKDB
echo "insert into skdb_group_permissions values ('myGroup', NULL, skdb_permission('rid'), 'root');" | $SKDB

# Let's check that user permissions are respected
# This should turn every user into "readonly"
echo "insert into skdb_user_permissions values (NULL, skdb_permission('r'));" | $SKDB

if echo -e "1\t235,\"myGroup\"" | $SKDB write-csv t2 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST USER PERMISSIONS:\tOK"
else
    echo -e "TEST USER PERMISSIONS:\tFAILED"
fi

# Let's check that user permissions are respected for a specific user
echo "insert into skdb_user_permissions values ('ID1', skdb_permission('ri'));" | $SKDB

if echo -e "1\t235,\"myGroup\"" | $SKDB write-csv t2 --user ID1 2>&1 | grep -q Error; then
    echo -e "TEST USER PERMISSIONS2:\tFAILED"
else
    echo -e "TEST USER PERMISSIONS2:\tOK"
fi

###############################################################################
# GROUP PERMISSIONS
###############################################################################

# Let's create a group
# user1 can write, all the others can only read
echo "insert into skdb_groups values('ID22', NULL, 'root', 'root');" | $SKDB
echo "insert into skdb_group_permissions values ('ID22', 'ID1', skdb_permission('rw'), 'root');" | $SKDB
echo "insert into skdb_group_permissions values ('ID22', 'ID2', skdb_permission('r'), 'root');" | $SKDB
echo "insert into skdb_group_permissions values ('ID22', 'ID3', skdb_permission('r'), 'root');" | $SKDB

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

# Let's change the user permissions and see what happens
echo "insert into skdb_user_permissions values ('ID2', skdb_permission(''))" | $SKDB

# Let's check that user2 cannot read
if $SKDB tail $subt1 --user ID2 2>&1 | grep -q "238|\"ID22\""; then
    echo -e "TEST GROUP PERMISSIONS6:\tFAILED"
else
    echo -e "TEST GROUP PERMISSIONS6:\tOK"
fi

echo "delete from skdb_user_permissions where userUUID='ID2';" | $SKDB

# Let's check that user2 can read again
if $SKDB tail $subt1 --user ID2 2>&1 | grep -q "238|\"ID22\""; then
    echo -e "TEST GROUP PERMISSIONS7:\tOK"
else
    echo -e "TEST GROUP PERMISSIONS7:\tFAILED"
fi

# Let's kick user2 out of the group
echo "delete from skdb_group_permissions where groupUUID='ID22' and userUUID='ID2';" | $SKDB

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
echo "insert into skdb_groups values('ID23', NULL, 'root', 'root');" | $SKDB
echo "insert into skdb_group_permissions values ('ID23', 'ID1', skdb_permission('r'), 'root');" | $SKDB
echo "insert into skdb_group_permissions values ('ID23', NULL, skdb_permission('rw'), 'root');" | $SKDB
echo "insert into skdb_user_permissions values ('ID2', skdb_permission('ri'));" | $SKDB

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
# Checking that we can encode a group ownership transfer.
###############################################################################

echo "DELETE FROM skdb_user_permissions WHERE userUUID IS NULL" | $SKDB

# We want to make sure that we can create a group that we can later
# transfer to someone else. The machinery is a little bit awkward.

# We first create a normal group, created by a user and controlled by
# a user, and then we transfer ownership to the group itself. This
# way, the only people who will be able to control the group (outside
# of the root of course), are the members of the group themselves. In
# this scenario, transfering ownership just consists in added a new
# member and removing the another.

echo "insert into skdb_users VALUES ('julienv', 'pass');" | $SKDB
echo "insert into skdb_users VALUES ('daniell', 'pass');" | $SKDB

# Prepare a group with only one member, julienv
echo -e "1\t\"myAdminGroup\", \"julienv\",\"julienv\", \"julienv\"" |
  $SKDB write-csv skdb_groups --user julienv --source 1234
echo -e "1\t\"myAdminGroup\", \"julienv\",7, \"julienv\"" |
  $SKDB write-csv skdb_group_permissions --user julienv --source 1234

# Past this point, julienv can do anything in the group myAdminGroup

# Add an entry so that julienv would also be admin if the admins of
# myAdminGroup were to change to myAdminGroup (itself).  This entry is
# not active because myAdminGroup is still pointing at julienv as an
# admin, but the moment we switch, that will not longer be the case.

echo -e "1\t\"myAdminGroup\", \"julienv\",7, \"myAdminGroup\"" |
  $SKDB write-csv skdb_group_permissions --user julienv --source 1234

# Now let's make the switch! Let's make myAdminGroup use myAdmingGroup
# (itself) as an admin. Note that the delete and the insert have to
# happen in the same transaction, otherwise we would lose access after
# the delete.
(echo -e "0\t\"myAdminGroup\", \"julienv\",\"julienv\", \"julienv\"";
 echo -e "1\t\"myAdminGroup\", \"julienv\",\"myAdminGroup\", \"myAdminGroup\"") |
  $SKDB write-csv skdb_groups --user julienv --source 1234

# Let's clean up after ourselves, this permission is no longer in use

echo -e "0\t\"myAdminGroup\", \"julienv\",7, \"julienv\"" |
  $SKDB write-csv skdb_group_permissions --user julienv --source 1234

# We have successfully create a group that is controlled by
# itself. And that contains one member, julienv.
# Let's try to transfer ownership to another user.

# First by adding the new user to the group

echo -e "1\t\"myAdminGroup\", \"daniell\",7, \"myAdminGroup\"" |
  $SKDB write-csv skdb_group_permissions --user julienv --source 1234

# And then by removing the original user

echo -e "0\t\"myAdminGroup\", \"julienv\",7, \"myAdminGroup\"" |
  $SKDB write-csv skdb_group_permissions --user julienv --source 1234

# That's it! daniell is in control now. Let's see if julienv can still
# modify the permissions (it should not be the case).

echo -e "0\t\"myAdminGroup\", \"daniell\",7, \"myAdminGroup\"" |
  $SKDB write-csv skdb_group_permissions --user julienv --source 1234 2>&1 |
  grep -q 'Error'

if [ "$?" -eq "0" ]; then
  echo -e "TEST CHANGE OWNERSHIP:\tOK"
else
  echo -e "TEST CHANGE OWNERSHIP:\tFAILED"
fi

# Let's check if daniell can indeed modify the permissions of the group

echo -e "1\t\"myAdminGroup\", \"julienv\",7, \"myAdminGroup\"" |
  $SKDB write-csv skdb_group_permissions --user daniell --source 1235 2>&1 |
  grep -q 'Error'

if [ "$?" -eq "0" ]; then
  echo -e "TEST CHANGE OWNERSHIP2:\tFAILED"
else
  echo -e "TEST CHANGE OWNERSHIP2:\tOK"
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
echo "delete from skdb_group_permissions where groupUUID='ID22' and userUUID='ID3';" | $SKDB

# As long as the row (238,22) is still there, the update did not kick in
while echo "select * from t3" | $SKDB | grep -q "238"; do
    sleep 1
done

# The reset was successful
echo -e "TEST GROUP PERMISSION UPDATE:\tOK"

# let's block the ID3 all together
echo "insert into skdb_user_permissions values('ID3', skdb_permission(''));" | $SKDB

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
 echo "insert into skdb_group_permissions values('ID22', 'ID3', skdb_permission('rw'), 'root');";
 echo "delete from skdb_user_permissions where userUUID='ID3';"
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
