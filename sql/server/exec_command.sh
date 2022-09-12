#!/bin/bash

read CMD

while read LINE; do
    echo "$LINE"
done | $CMD 2>&1
