#!/bin/bash

time ./run_all_tests.sh > /tmp/test_output

check=`grep -v OK /tmp/test_output | grep -v '*' | grep -v passed | grep -v Stress | tr -d '\n'`

if [ -z "$check" ]
then
      echo "SUCCESS"
else
      echo "FAILED (details in /tmp/test_output)"
fi
