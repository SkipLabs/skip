#!/bin/bash

diff -B -w $1 $2
if [ $? -eq 0 ]; then
    diff -B -w $3 $4
    if [ $? -eq 0 ]; then
        echo "OK"
    else
        echo "FAILED"
    fi
else
    echo "FAILED"
fi
