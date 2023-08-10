#!/bin/bash

# Convert parameter values from json map to sqlite parameters
#
# For example:
# $ echo '{"key": "value"}' | ./json_args_to_sqlite_params.sh
# .param set @key "'value'"
#
# See also test_args.json and expected_params.sql

jq --raw-output 'to_entries | .[] | if (.value | type) == "string" then ".param set @\(.key) \"'\''\(.value)'\''\"" else ".param set @\(.key) \(.value)" end' $1
