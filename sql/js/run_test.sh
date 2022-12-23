#!/bin/bash

skdb=../../build/skdb

run_test () {
  echo -en "$1:\t"
  tmpfile1=$(mktemp /tmp/testfile.XXXXXX)
  tmpfile2=$(mktemp /tmp/testfile.XXXXXX)
  cat ../test/$1.sql | $skdb --always-allow-joins > $tmpfile1
  cd ../../ && cat build/skdb_node.js sql/js/tests/$1.jsx | node | egrep -v '^[ ]*$' > $tmpfile2
  diff $tmpfile1 $tmpfile2 > /dev/null
  if [ $? -eq 0 ]; then
      rm $tmpfile1 $tmpfile2
      echo "OK"
  else
      echo "FAILED"
  fi
}

run_test select1
