#!/bin/bash

rm -f /tmp/test.db

SQLIVE=../../../../build/sqlive

$SQLIVE --init /tmp/test.db

cat create.sql | $SQLIVE --data /tmp/test.db

for i in {1..10}
do
    cat inserts.sql | $SQLIVE --data /tmp/test.db  &
done
wait

echo "SELECT * FROM t1;" | $SQLIVE --data /tmp/test.db  > /tmp/test_result
sum=`cat /tmp/test_result | egrep '^[0-9]+$' | awk '{x += $1} END {print x}'`

if [[ sum -eq 1048576 ]]
then
   echo -e "CONCURRENT SUM:\tOK"
else
    echo -e "CONCURRENT SUM:\tERROR"
fi




