#!/bin/bash

SKDB=./target/skdb
export SKDB

run_test () {
  echo -en "$1:\t"
  out1=$(mktemp)
  err1=$(mktemp)
  out2=$(mktemp)
  err2=$(mktemp)
  cat $1 | $SKDB --always-allow-joins 2> $err1 | sort > $out1
  stat1=${PIPESTATUS[1]}
  cat $1 | sqlite3 2> $err2 | sort > $out2
  stat2=${PIPESTATUS[1]}
  if [ $stat1 -eq 0 ]; then
      if [ $stat2 -eq 0 ]; then
          diff $out1 $out2 > /dev/null
          if [ $? -eq 0 ]; then
              echo "OK"
          else
              echo "FAILED"
          fi
      else
          echo "FAILED (only sqlite exited $stat2)"
          diff $err1 $err2
      fi
  else
      if [ $stat2 -eq 0 ]; then
          echo "FAILED (only skdb exited $stat1)"
          diff $err1 $err2
      else
          echo "OK (both exited non-zero)"
      fi
  fi
}
export -f run_test

run_one_test () {
  cat $1 | time $SKDB --always-allow-joins | sort > /tmp/kk1
  cat $1 | time sqlite3 | sort > /tmp/kk2
  diff /tmp/kk1 /tmp/kk2
  if [ $? -eq 0 ]; then
     echo "OK"
  fi
}

echo ""
echo "*******************************************************************************"
echo "* UNIT TESTS *"
echo "*******************************************************************************"
echo ""

./unit_tests.sh

echo ""
echo "*******************************************************************************"
echo "* SKDB TESTS *"
echo "*******************************************************************************"
echo ""

if ! [ -z "$1" ]; then
    if test -f "$1"; then
        echo "RUNNING TEST: $1"
        run_one_test $1
    else
        echo "File does not exist: $1"
    fi
    exit 0
fi

parallel run_test ::: \
    test/*.sql \
    test/random/expr/*.sql \
    test/random/select/*.sql \
    test/random/groupby/*.sql \
    test/random/aggregates/*.sql

echo ""
echo "*******************************************************************************"
echo "* SKDB REPLICATION TESTS *"
echo "*******************************************************************************"
echo ""

./test_replication.sh

echo ""
echo "*******************************************************************************"
echo "* SKDB CONCURRENCY TESTS *"
echo "*******************************************************************************"
echo ""

for i in {1..10}; do ./test_concurrent_sync.sh; done
for i in {1..10}; do (cd ./test/concurrent/inserts/ && ./run.sh); done
for i in {1..10}; do (cd ./test/concurrent/sum/ && ./run.sh); done
for i in {1..10}; do (cd ./test/concurrent/sum_transaction/ && ./run.sh); done


echo ""
echo "*******************************************************************************"
echo "* SKDB DIFF TESTS *"
echo "*******************************************************************************"
echo ""

./test_diff.sh

echo ""
echo "*******************************************************************************"
echo "* MEMORY *"
echo "*******************************************************************************"
echo ""

(cd ./test/memory/ && ./run.sh)
