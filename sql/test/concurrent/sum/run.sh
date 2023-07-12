#!/bin/bash

pass() { printf "%-20s OK\n" "$1:"; }
fail() { printf "%-20s FAILED\n" "$1:"; }

rm -f /tmp/test.db

SKDB=../../../target/skdb

$SKDB --init /tmp/test.db

cat create.sql | $SKDB --data /tmp/test.db

for i in {1..10}
do
    cat inserts.sql | $SKDB --data /tmp/test.db &
done
wait

echo "SELECT * FROM t1;" | $SKDB --data /tmp/test.db  > /tmp/test_result
sum=`cat /tmp/test_result | egrep '^[0-9]+$' | awk '{x += $1} END { print (x == 1099511627776) }'`

if [[ sum -eq 1 ]]
then
  pass "CONCURRENT SUM"
else
  fail "CONCURRENT SUM"
fi
