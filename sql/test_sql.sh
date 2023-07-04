#!/bin/bash

SKDB=./target/skdb
export SKDB

run_test () {
  echo -en "$1:\t"
  kk1=$(mktemp)
  kk2=$(mktemp)
  cat $1 | $SKDB --always-allow-joins | sort > $kk1
  cat $1 | sqlite3 | sort > $kk2
  diff $kk1 $kk2 > /dev/null
  if [ $? -eq 0 ]; then
      echo "OK"
  else
      echo "FAILED"
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
    test/select1_large.sql \
    test/select2_large.sql \
    test/select3_large.sql \
    test/select1.sql \
    test/select2.sql \
    test/select3.sql \
    test/select4.1.sql \
    test/select5.1.sql \
    test/insert-reorder.sql \
    test/case_insensitive.sql \
    test/random/expr/*.sql \
    test/random/select/*.sql \
    test/random/groupby/*.sql \
    test/random/aggregates/*.sql \
    test/comments.sql
    # test/select4.2.sql \
    # test/select5.2.sql \

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
