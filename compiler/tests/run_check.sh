#!/bin/bash


CC=clang-10
CPP=clang++-10
OLEVEL=-O0
RUNTIME=../build/libskip_runtime64.a

EXP="${1%.out}.exp"
EXP_ERR="${1%.out}.exp_err"
ERR="${1%.out}.err"

if test -f "$EXP_ERR"; then
    diff -B -w $EXP_ERR $ERR > /dev/null
    if [ $? -eq 0 ]; then
        echo -e $1 "\tOK"
    else
        echo -e $1 "\tFAILED"
    fi
else
    echo -e $1 "\tOK"
fi
