#!/bin/bash

rm -f /tmp/test.db /tmp/test2.db

skdb --init /tmp/test.db --capacity $((1024 * 1024)) > /dev/null

echo "create table t1 (a INTEGER, b INTEGER, c INTEGER);" | skdb --data /tmp/test.db

for i in {1..10000}; do
    echo "insert into t1 values ($i, $i, $i);" | skdb --data /tmp/test.db 2> /dev/null
    if [ $? -ne 0 ]
    then
        break 1
    fi
done

skdb --init /tmp/test2.db
skdb --data /tmp/test.db --dump | skdb --data /tmp/test2.db

j=`echo "select 1 + max(a) from t1;" | skdb --data /tmp/test2.db`

if [ $i -eq $j ]
then
    echo -e "TEST CAPACITY:\tOK"
else
    echo -e "TEST CAPACITY:\tFAILED"
fi
