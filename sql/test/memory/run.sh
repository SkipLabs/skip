#!/bin/bash

rm -f /tmp/test.db

skdb --init /tmp/test.db

echo "create table t1 (a INTEGER);" | skdb --data /tmp/test.db

(echo "begin transaction;"; for i in {1..2000}; do echo "insert into t1 values ($i);"; done; echo "commit;") | skdb --data /tmp/test.db

size1=`skdb --size --data /tmp/test.db`

echo "delete from t1 where a > 0;" | skdb --data /tmp/test.db

size2=`skdb --size --data /tmp/test.db`

skdb --size --data /tmp/test.db --compact

size3=`skdb --size --data /tmp/test.db`

if (( size2 > size1 ));
then
    echo "TEST CHECKING IF SIZE WENT DOWN AFTER DELETE FAILED"
fi


if (( size3 > size2 ));
then
    echo "TEST CHECKING IF SIZE WENT DOWN AFTER COMPACTION FAILED"
fi

    
