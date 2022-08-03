#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

col=80


CC=clang-10
CPP=clang++-10
OLEVEL=-O0
RUNTIME=../build/libskip_runtime64.a

TEST_EXP="${1%.out}.exp"
EXP=${TEST_EXP#"../build/tests/"}
TEST_EXP_ERR="${1%.out}.exp_err"
EXP_ERR=${TEST_EXP_ERR#"../build/tests/"}
ERR="${1%.out}.err"

if test -f "$EXP_ERR"; then
    diff -B -w $EXP_ERR $ERR > /dev/null
    if [ $? -eq 0 ]; then
        touch $1
        printf '%s%s%*s%s\n' "$1" "$GREEN" $((col-${#1})) "[OK]" "$NORMAL"
    else
        printf '%s%s%*s%s\n' "$1" "$RED" $((col-${#1})) "[FAILED]" "$NORMAL"
    fi
else
    if [ -s "$ERR" ]; then
        printf '%s%s%*s%s\n' "$1" "$RED" $((col-${#1})) "[FAILED]" "$NORMAL"
        exit 2
    fi
    $CPP $OLEVEL "${1%.out}.ll" $RUNTIME -o "${1%.out}.bin" -Wl,--whole-archive -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive
    "${1%.out}.bin" > $1
    diff -B -w $1 $EXP > /dev/null
    if [ $? -eq 0 ]; then
        touch $1
        printf '%s%s%*s%s\n' "$1" "$GREEN" $((col-${#1})) "[OK]" "$NORMAL"
    else
        printf '%s%s%*s%s\n' "$1" "$RED" $((col-${#1})) "[FAILED]" "$NORMAL"
    fi
fi

