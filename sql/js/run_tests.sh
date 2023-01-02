#!/bin/bash

skdb=../../build/skdb

run_compare_test () {
  echo -en "$1:\t"
  tmpfile1=$(mktemp /tmp/testfile.XXXXXX)
  tmpfile2=$(mktemp /tmp/testfile.XXXXXX)
  cat ../test/$1.sql | $skdb --always-allow-joins > $tmpfile1
  (cd ../../ && cat build/skdb_node.js sql/js/tests/$1.jsx | node) | egrep -v '^[ ]*$' > $tmpfile2
  diff $tmpfile1 $tmpfile2 > /dev/null
  if [ $? -eq 0 ]; then
      rm $tmpfile1 $tmpfile2
      echo -e "OK"
  else
      echo -e "FAILED"
  fi
}

run_compare_test select1

if
    (cd ../../ && (
        cat build/skdb_node.js;
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');"
        echo "  skdb.sqlRaw('insert into t1 values(TRUE, false);');"
        echo "  console.log(skdb.sqlRaw('select true, false, a, b from t1;'));"
        echo "}"
        echo "test()"
    ) | node) | grep -q '1|0|1|0'
then
    echo -e "TEST JS BOOLEAN:\tOK"
else
    echo -e "TEST JS BOOLEAN:\tFAILED"
fi

if
    (cd ../../ && (
        cat build/skdb_node.js;
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');"
        echo "  skdb.sqlRaw('create table if not exists t1 (a BOOLEAN, b boolean);');"
        echo "  console.log(skdb.sqlRaw('select 1;'));"
        echo "}"
        echo "test()"
    ) | node)| grep -q '1'
then
    echo -e "TEST JS CREATE TABLE IF NOT EXISTS:\tOK"
else
    echo -e "TEST JS CREATE TABLE IF NOT EXISTS:\tFAILED"
fi
