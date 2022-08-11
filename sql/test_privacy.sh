#!/bin/bash

rm -f /tmp/test.db

skdb --init /tmp/test.db
cat privacy/init.sql | skdb --data /tmp/test.db

echo "INSERT INTO sk_users VALUES (id(), 'julienv');" | skdb --data /tmp/test.db
