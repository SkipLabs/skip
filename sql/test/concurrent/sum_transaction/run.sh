#!/bin/bash


SQLIVE=../../../../build/sqlive

rm -f /tmp/test.db

$SQLIVE --init /tmp/test.db

cat create.sql | $SQLIVE --data /tmp/test.db

for i in {1..20}
do
    cat inserts.sql | $SQLIVE --data /tmp/test.db &
done
wait

echo "SELECT * FROM t1;" | $SQLIVE --data /tmp/test.db  > /tmp/test_result
sum=`cat /tmp/test_result | egrep '^[0-9]+$' | awk '{x += $1} END {print x}'`

if [[ sum -eq 68152531241598345216 ]]
then
   echo -e "CONCURRENT SUM:\tOK"
else
    echo -e "CONCURRENT SUM:\tERROR"
fi


