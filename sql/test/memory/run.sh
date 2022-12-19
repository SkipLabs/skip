#!/bin/bash

SKDB=/skfs_build/build/skdb

rm -f /tmp/test.db

$SKDB --init /tmp/test.db

echo "create table t1 (a INTEGER);" | $SKDB --data /tmp/test.db

(echo "begin transaction;"; for i in {1..2000}; do echo "insert into t1 values ($i);"; done; echo "commit;") | $SKDB --data /tmp/test.db

size1=$($SKDB --size --data /tmp/test.db)

echo "delete from t1 where a > 0;" | $SKDB --data /tmp/test.db

size2=$($SKDB --size --data /tmp/test.db)

$SKDB --size --data /tmp/test.db --compact

size3=$($SKDB --size --data /tmp/test.db)

if (( size2 > size1 ));
then
    echo "TEST CHECKING IF SIZE WENT DOWN AFTER DELETE FAILED"
fi


if (( size3 > size2 ));
then
    echo "TEST CHECKING IF SIZE WENT DOWN AFTER COMPACTION FAILED"
fi
