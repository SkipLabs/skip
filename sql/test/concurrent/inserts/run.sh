#!/bin/bash

rm -f /tmp/test.db

SKDB=../../../../build/skdb

$SKDB --init /tmp/test.db

cat create.sql | $SKDB --data /tmp/test.db

for i in {1..4}
do
    cat inserts.sql | $SKDB --data /tmp/test.db &
done
wait

echo "SELECT * FROM t1;" | $SKDB --data /tmp/test.db  > /tmp/test_result
sum=`cat /tmp/test_result | egrep '^[0-9]+$' | awk '{x += $1} END {print x}'`

if [[ sum -eq 65536 ]]
then
   echo -e "CONCURRENT INSERTS:\tOK"
else
    echo -e "CONCURRENT INSERTS:\tERROR"
fi

