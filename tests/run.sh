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
    $CPP $OLEVEL "${1%.out}.ll" $RUNTIME -o "${1%.out}.bin" -Wl,--whole-archive -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive
    "${1%.out}.bin" > $1
    diff -B -w $1 $EXP > /dev/null
    if [ $? -eq 0 ]; then
        touch $1
        echo -e $1 "\tOK"
    else
        touch $1
        echo -e $1 "\tFAILED"
    fi
fi
