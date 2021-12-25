#!/bin/bash

rm -f /tmp/test.db

skdb --init /tmp/test.db

echo "create table t1 (a INTEGER);" | skdb --data /tmp/test.db

rm -f /tmp/nn

echo "create virtual view v1 as select * from t1;" | skdb --data /tmp/test.db

skdb --connect v1 --notify /tmp/nn --data /tmp/test.db > /dev/null

n1=`cat /tmp/nn`

echo "insert into t1 values(22);" | skdb --data /tmp/test.db

n2=`cat /tmp/nn`

echo "insert into t1 values(23);" | skdb --data /tmp/test.db

n3=`cat /tmp/nn`

if (( n1 < n2 ))
then
    echo -e "TEST NOTIFY1:\tOK"
else
    echo -e "TEST NOTIFY1:\tFAILED"
fi

if (( n2 < n3 ))
then
    echo -e "TEST NOTIFY2:\tOK"
else
    echo -e "TEST NOTIFY2:\tFAILED"
fi
