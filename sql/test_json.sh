#!/bin/bash

pass() { printf "%-32s OK\n" "TEST $1:"; }
fail() { printf "%-32s FAILED\n" "TEST $1:"; }

DBFILE=/tmp/test.db

rm -f $DBFILE

if [ -z "$SKARGO_PROFILE" ]; then
    SKARGO_PROFILE=dev
fi

SKDB_CMD="skargo run --profile $SKARGO_PROFILE -- "

$SKDB_CMD --init $DBFILE

SKDB="$SKDB_CMD --data $DBFILE"

echo "create table t1 (id TEXT PRIMARY KEY, object JSON);" | $SKDB
echo "create table t2 (id TEXT PRIMARY KEY, object TEXT);" | $SKDB

echo "insert into t1 (object) values (json('{\"a\": 32}'));" | $SKDB
echo "insert into t1 (object) values (json('{\"a\": 33, \"b\": 3.3}'));" | $SKDB
echo "insert into t1 (object) values (json('{\"a\": 33, \"b\": 3.3, \"c\":\"text\"}'));" | $SKDB

echo "insert into t2 (object) values ('{\"a\": 34}');" | $SKDB
echo "insert into t2 (object) values ('{\"a\": 34, \"b\": 3.4}');" | $SKDB
echo "insert into t2 (object) values ('{\"a\": 34, \"b\": 3.4, \"c\":\"text2\"}');" | $SKDB


if echo "select json_infer_schema(object) from t1" | $SKDB | grep -q '{"a":int,?"b":float,?"c":string}'; then
    pass "INFER_SCHEMA"
else
    fail "INFER_SCHEMA"
fi

if echo "select json_infer_schema(object) from t2" | $SKDB | grep -q '{"a":int,?"b":float,?"c":string}'; then
    pass "INFER_SCHEMA"
else
    fail "INFER_SCHEMA"
fi

schema='{"a":int,?"b":float,?"c":string}'

if echo "select json_check_schema(json_schema('$schema'), json('{\"a\":22}'))" | $SKDB | grep -q ok; then
    pass "SCHEMA_CHECK1"
else
    fail "SCHEMA_CHECK1"
fi

if echo "select json_check_schema('$schema', '{\"a\":22}')" | $SKDB | grep -q ok; then
    pass "SCHEMA_CHECK1"
else
    fail "SCHEMA_CHECK1"
fi


if echo "select json_check_schema(json_schema('$schema'), json('{\"a\":22.0}'))" | $SKDB 2>&1 | grep -q Error; then
    pass "SCHEMA_CHECK2"
else
    fail "SCHEMA_CHECK2"
fi

if echo "select json_check_schema('$schema', '{\"a\":22.0}')" | $SKDB 2>&1 | grep -q Error; then
    pass "SCHEMA_CHECK2"
else
    fail "SCHEMA_CHECK2"
fi

if echo "select json_check_schema('$schema', '{\"a\":22.0}')" | $SKDB 2>&1 | grep -q Error; then
    pass "SCHEMA_CHECK2"
else
    fail "SCHEMA_CHECK2"
fi

if echo "select json_check_schema(json_schema('$schema'), json('{\"b\":22.0}'))" | $SKDB 2>&1 | grep -q Error; then
    pass "SCHEMA_CHECK2"
else
    fail "SCHEMA_CHECK2"
fi

echo "create virtual view paths as json_split(t1);" | $SKDB

if echo "select count(*) from paths where path='.a'" | $SKDB | grep -q 3; then
    pass "COUNT_PATHS"
else
    fail "COUNT_PATHS"
fi

echo "\"id555\", \"{\"\"c\"\":33}\"" | $SKDB load-csv t1
echo "\"id555\", \"{\"\"c\"\":33}\"" | $SKDB load-csv t2

schema2='{?"a":int,?"b":float,?"c":int|string}'

# Let's enforce a schema on t1, see if it is successfully enforced

echo "create virtual view enforce_type as select json_check_schema('$schema2', json_infer_schema(object)) from t1" | $SKDB

# Now let's try to add something that does not respect the schema

if echo "insert into t1 values('$schema2', '{\"c\":3.3}');" | $SKDB 2>&1 | grep -q Error; then
    pass "ENFORCE_SCHEMA"
else
    fail "ENFORCE_SCHEMA"
fi
