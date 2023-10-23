#!/bin/bash

rm -f /tmp/test.db

skdb --init /tmp/test.db
SKDB="skdb --data /tmp/test.db"

cat privacy/init.sql test_auction.sql | $SKDB

# Let's create a few users
echo "insert into skdb_users values (33, 'user33', 'pass33');" | $SKDB
echo "insert into skdb_users values (34, 'user34', 'pass34');" | $SKDB
echo "insert into skdb_users values (35, 'user35', 'pass35');" | $SKDB


echo "insert into skdb_table_permissions values ('bids', 3);" | $SKDB
echo "insert into skdb_table_permissions values ('items', 3);" | $SKDB

# Let's create items

echo -e "1\t44,\"OPEN\",\"LAMP\", 100, 33" | $SKDB write-csv --user user33
echo -e "1\t44,\"OPEN\",\"PAINTING\", 50, 33" | $SKDB write-csv --user user33

# Let's bid!

# echo "select * from skdb_table_permissions;" | $SKDB

echo -e "1\t44, 1000, 34" | $SKDB write-csv --user user34
echo -e "1\t44, 1100, 35" | $SKDB write-csv --user user35

$SKDB tail `$SKDB subscribe bids_by_user` --user user34
echo "select * from bids_by_user;" | $SKDB


