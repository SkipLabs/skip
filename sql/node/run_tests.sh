#!/bin/bash

skdb=../../build/skdb
cp ../js/skdb.wasm .
node=./node_modules/node/bin/node

run_compare_test () {
  echo -en "$1:\t"
  tmpfile1=$(mktemp /tmp/testfile.XXXXXX)
  tmpfile2=$(mktemp /tmp/testfile.XXXXXX)
  cat ../test/$1.sql | $skdb --always-allow-joins > $tmpfile1
  ((cat ../../build/skdb_node.js; echo ""; cat tests/$1.jsx) | $node) | egrep -v '^[ ]*$' > $tmpfile2
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
    ((cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  let skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');"
        echo "  skdb.sqlRaw('insert into t1 values(TRUE, false);');"
        echo "  console.log(skdb.sqlRaw('select true, false, a, b from t1;'));"
        echo "}"
        echo "test()"
    )| $node) | grep -q '1|0|1|0'
then
    echo -e "TEST JS BOOLEAN:\tOK"
else
    echo -e "TEST JS BOOLEAN:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');"
        echo "  skdb.sqlRaw('create table if not exists t1 (a BOOLEAN, b boolean);');"
        echo "  console.log(skdb.sqlRaw('select 1;'));"
        echo "}"
        echo "test()"
    ) | $node)| grep -q '1'
then
    echo -e "TEST JS CREATE TABLE IF NOT EXISTS:\tOK"
else
    echo -e "TEST JS CREATE TABLE IF NOT EXISTS:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a STRING PRIMARY KEY);');"
        echo "}"
        echo "test()"
    ) | $node)
then
    echo -e "TEST STRING PRIMARY KEY:\tOK"
else
    echo -e "TEST STRING PRIMARY KEY:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a STRING PRIMARY KEY, b INTEGER);');"
        echo "  skdb.sqlRaw('insert into t1 (b) values (22);');";
        echo "}"
        echo "test()"
    ) | $node)2>&1| grep -q 'Cannot generate a string primary key'
then
    echo -e "TEST STRING PRIMARY KEY2:\tOK"
else
    echo -e "TEST STRING PRIMARY KEY2:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sql('create table widgets (id text unique, name text);');"
        echo "  skdb.sql('INSERT INTO widgets (id, name) VALUES (\'a\', \'gear\');');"
        echo "  skdb.sql('UPDATE widgets SET id = \'c\', name = \'gear2\';');"
        echo "  console.log(skdb.sqlRaw('select * from widgets;'));"
        echo "}"
        echo "test()"
     ) | $node) | grep -q 'c|gear2'
then
    echo -e "TEST MULTIPLE FIELD UPDATES:\tOK"
else
    echo -e "TEST MULTIPLE FIELD UPDATES:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sql(\"create table widgets (id text unique , price real not null);\");"
        echo "  skdb.sql(\"INSERT INTO widgets (id, price) values ('a', 10.0);\");"
        echo "  console.log(skdb.sqlRaw('select * from widgets'))"
        echo "}"
        echo "test()"
     ) | $node) | grep -q 'a|10.0'
then
    echo -e "TEST PARSE/PRINT FLOAT:\tOK"
else
    echo -e "TEST PARSE/PRINT FLOAT:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');"
        echo "  skdb.sqlRaw('create virtual view v1 as select * from t1;');"
        echo "  skdb.sqlRaw('create virtual view if not exists v1 as select * from t1;');"
        echo "  console.log(skdb.sqlRaw('select 1;'));"
        echo "}"
        echo "test()"
    ) | $node)| grep -q '1'
then
    echo -e "TEST JS VIRTUAL VIEW IF NOT EXISTS:\tOK"
else
    echo -e "TEST JS VIRTUAL VIEW IF NOT EXISTS:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sqlRaw('create table t1 (a BOOLEAN, b boolean);');"
        echo "  skdb.sqlRaw('create view v1 as select * from t1;');"
        echo "  skdb.sqlRaw('create view if not exists v1 as select * from t1;');"
        echo "  console.log(skdb.sqlRaw('select 1;'));"
        echo "}"
        echo "test()"
    ) | $node)| grep -q '1'
then
    echo -e "TEST JS VIEW IF NOT EXISTS:\tOK"
else
    echo -e "TEST JS VIEW IF NOT EXISTS:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  for(let i = 0; i < 10000; i++) {"
        echo "    skdb.sqlRaw('select * from t1;');"
        echo "    console.log('');"
        echo "  }"
        echo "}"
        echo "test()"
    ) | $node 2>&1)| grep 'does not exist' | awk '{count += 1;} END { print count;}' | grep -q 10000
then
    echo -e "TEST ERROR MEMORY:\tOK"
else
    echo -e "TEST ERROR MEMORY:\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        echo "";
        echo "async function test() {"
        echo "  skdb = await SKDB.create(true);"
        echo "  skdb.sql('create table t1 (aBc INTEGER)')"
        echo "  skdb.insert('t1', [11]);"
        echo "  console.log(skdb.sql('select * from t1')[0].aBc);"
        echo "}"
        echo "test()"
    ) | $node 2>&1) | grep -q "11"
then
    echo -e "TEST COLUMN CASING:\tOK"
else
    echo -e "TEST COLUMN CASING :\tFAILED"
fi

if
    ((
        cat ../../build/skdb_node.js;
        cat tests/test_root.js
    ) | $node 2>&1) | tr '\n' 'S' | grep -q 'todos \[\]S'
then
    echo -e "TEST ROOT:\tOK"
else
    echo -e "TEST ROOT :\tFAILED"
fi
