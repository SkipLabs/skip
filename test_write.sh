#!/bin/bash

rm -f /tmp/data
rm -f /tmp/data2
rm -f /tmp/test.out
rm -f /tmp/inter.out

build/sqlive --init /tmp/data

# creates a "/tmp/" directory in the database
build/sqlive --test createDir --data /tmp/data

build/sqlive --init /tmp/data2
build/sqlive --test createDir --data /tmp/data2

# Connnects the directory /tmp/mapped from data2 to /tmp/ from data1
build/sqlive --data /tmp/data2 --connect /tmp/mapped/ --cmd "build/sqlive --data /tmp/data --write /tmp/"

build/sqlive --data /tmp/data2 --connect /tmp/mapped/ --cmd "cat >> /tmp/inter.out"

# Connnects the directory /tmp/mapped from data to a file
build/sqlive --data /tmp/data --connect /tmp/mapped/ --cmd "cat >> /tmp/test.out"

echo -e "key1\tvalue1" | build/sqlive --data /tmp/data2 --write /tmp/
echo -e "key2\tvalue2\nkey2\tvalue23" | build/sqlive --data /tmp/data2 --write /tmp/
echo -e "key2\n" | build/sqlive --data /tmp/data2 --write /tmp/
echo -e "key2\tvalue2\nkey2\tvalue23" | build/sqlive --data /tmp/data2 --write /tmp/

echo -e "key1\tvalue1\nkey1\nkey1\tvalue23" | build/sqlive --data /tmp/data --write /tmp/

#for i in {1..10}; do echo -e "$i\t$i\n"; done | build/sqlive --data /tmp/data2 --write /tmp/

cat /tmp/inter.out
