#!/bin/bash

if cat test/test_unique.sql | ../build/sqlive 2>&1 | grep -q UNIQUE
then
    echo "OK"
else 
    echo "FAILED"
fi


if cat test/test_concat.sql | ../build/sqlive | grep -q hellohello
then
    echo "OK"
else 
    echo "FAILED"
fi
