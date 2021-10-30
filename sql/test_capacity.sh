#!/bin/bash

rm -f /tmp/test.db /tmp/test2.db

sqlive --init /tmp/test.db --capacity $((1024 * 1024)) > /dev/null

echo "create table t1 (a INTEGER, b INTEGER, c INTEGER);" | sqlive --data /tmp/test.db

for i in {1..10000}; do
    echo "insert into t1 values ($i, $i, $i);" | sqlive --data /tmp/test.db 2> /dev/null
    if [ $? -ne 0 ]
    then
        break 1
    fi
done

sqlive --init /tmp/test2.db
sqlive --data /tmp/test.db --dump | sqlive --data /tmp/test2.db

j=`echo "select 1 + max(a) from t1;" | sqlive --data /tmp/test2.db`

if [ $i -eq $j ]
then
    echo -e "TEST CAPACITY:\tOK"
else
    echo -e "TEST CAPACITY:\tFAILED"
fi
