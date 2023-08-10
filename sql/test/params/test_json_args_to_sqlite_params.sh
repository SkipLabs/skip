#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR

./json_args_to_sqlite_params.sh test_args.json | diff - expected_params.sql
if [ $? -eq 0 ]; then
    echo "OK"
fi
