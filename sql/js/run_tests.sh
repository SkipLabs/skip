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

if
    (cd ../../ && (
        cat build/skdb_node.js;
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a STRING PRIMARY KEY);');"
        echo "}"
        echo "test()"
    ) | node)
then
    echo -e "TEST STRING PRIMARY KEY:\tOK"
else
    echo -e "TEST STRING PRIMARY KEY:\tFAILED"
fi

if
    (cd ../../ && (
        cat build/skdb_node.js;
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a STRING PRIMARY KEY, b INTEGER);');"
        echo "  skdb.sqlRaw('insert into t1 (b) values (22);');";
        echo "}"
        echo "test()"
    ) | node)2>&1| grep -q 'Cannot generate a string primary key'
then
    echo -e "TEST STRING PRIMARY KEY2:\tOK"
else
    echo -e "TEST STRING PRIMARY KEY2:\tFAILED"
fi

if
    (cd ../../ && (
        cat build/skdb_node.js;
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sql('create table widgets (id text unique, name text);');"
        echo "  skdb.sql('INSERT INTO widgets (id, name) VALUES (\'a\', \'gear\');');"
        echo "  skdb.sql('UPDATE widgets SET id = \'c\', name = \'gear2\';');"
        echo "  console.log(skdb.sqlRaw('select * from widgets;'));"
        echo "}"
        echo "test()"
     ) | node) | grep -q 'c|gear2'
then
    echo -e "TEST MULTIPLE FIELD UPDATES:\tOK"
else
    echo -e "TEST MULTIPLE FIELD UPDATES:\tFAILED"
fi

if
    (cd ../../ && (
        cat build/skdb_node.js;
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sql(\"create table widgets (id text unique , price real not null);\");" 
        echo "  skdb.sql(\"INSERT INTO widgets (id, price) values ('a', 10.0);\");"
        echo "  console.log(skdb.sqlRaw('select * from widgets'))"
        echo "}"
        echo "test()"
     ) | node) | grep -q 'a|10.0'
then
    echo -e "TEST PARSE/PRINT FLOAT:\tOK"
else
    echo -e "TEST PARSE/PRINT FLOAT:\tFAILED"
fi

if
    (cd ../../ && (
        cat build/skdb_node.js;
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');"
        echo "  skdb.sqlRaw('create virtual view v1 as select * from t1;');"
        echo "  skdb.sqlRaw('create virtual view if not exists v1 as select * from t1;');"
        echo "  console.log(skdb.sqlRaw('select 1;'));"
        echo "}"
        echo "test()"
    ) | node)| grep -q '1'
then
    echo -e "TEST JS VIRTUAL VIEW IF NOT EXISTS:\tOK"
else
    echo -e "TEST JS VIRTUAL VIEW IF NOT EXISTS:\tFAILED"
fi

if
    (cd ../../ && (
        cat build/skdb_node.js;
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');"
        echo "  skdb.sqlRaw('create view v1 as select * from t1;');"
        echo "  skdb.sqlRaw('create view if not exists v1 as select * from t1;');"
        echo "  console.log(skdb.sqlRaw('select 1;'));"
        echo "}"
        echo "test()"
    ) | node)| grep -q '1'
then
    echo -e "TEST JS VIEW IF NOT EXISTS:\tOK"
else
    echo -e "TEST JS VIEW IF NOT EXISTS:\tFAILED"
fi
