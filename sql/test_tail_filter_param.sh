#!/bin/bash

pass() { printf "%-40s OK\n" "$1:"; }
fail() { printf "%-40s FAILED\n" "$1:"; }

db=$(mktemp)
rm -f $db
tailfile=$(mktemp)
out1=$(mktemp)
out2=$(mktemp)

./target/release/skdb --init $db
skdb="./target/release/skdb --data $db"

echo "create table t1 (a INTEGER);" | $skdb

sessionID=`$skdb subscribe t1 --connect`

echo '{ "bound": 500 }' \
| $skdb tail --expect-query-params $sessionID --follow 'a > @bound' \
> $tailfile &
tailerID=$!

for i in {1..1000}; do
    echo "insert into t1 values($i);"
done | $skdb

sleep 1

echo "create table t2 (a INTEGER);" | $skdb
cat $tailfile | $skdb write-csv t2 > /dev/null

echo "select * from t1 where a > 500;" | $skdb > $out1
echo "select * from t2;" | $skdb > $out2

diff -q $out1 $out2
if [ $? -eq 0 ]; then
    pass "TAIL FILTER PARAM TEST"
else
    fail "TAIL FILTER PARAM TEST"
fi
