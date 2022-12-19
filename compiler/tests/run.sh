#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)
COL=80
CC=clang-10
CPP=clang++-10
OLEVEL=-O0
RUNTIME=../../build/libskip_runtime64.a

TEST_EXP="${1%.test}.exp"
EXP=${TEST_EXP#"../../build/tests/"}
TEST_EXP_ERR="${1%.test}.exp_err"
EXP_ERR=${TEST_EXP_ERR#"../../build/tests/"}
ERR="${1%.test}.err"

if test -f "$EXP_ERR"; then
    diff -B -w $EXP_ERR $ERR > /dev/null
    if [ $? -eq 0 ]; then
        touch $1
        printf '%s%s%*s%s\n' "$1" "$GREEN" $((COL-${#1})) "[OK]" "$NORMAL"
    else
        printf '%s%s%*s%s\n' "$1" "$RED" $((COL-${#1})) "[FAILED]" "$NORMAL"
    fi
else
    if [ -s "$ERR" ]; then
        printf '%s%s%*s%s\n' "$1" "$RED" $((COL-${#1})) "[FAILED]" "$NORMAL"
        exit 2
    fi
    $CPP $OLEVEL "${1%.test}.ll" $RUNTIME -o "${1%.test}.bin" -Wl,--whole-archive -static -lrt -Wl,--whole-archive -lpthread -Wl,--no-whole-archive
    "${1%.test}.bin" > "${1%.test}.out"
    diff -B -w "${1%.test}.out" $EXP > /dev/null
    if [ $? -eq 0 ]; then
        touch $1
        printf '%s%s%*s%s\n' "$1" "$GREEN" $((COL-${#1})) "[OK]" "$NORMAL"
    else
        printf '%s%s%*s%s\n' "$1" "$RED" $((COL-${#1})) "[FAILED]" "$NORMAL"
    fi
fi
