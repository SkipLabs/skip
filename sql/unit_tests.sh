#!/bin/bash

SKDB=./target/skdb

if cat test/unit/test_unique.sql | $SKDB 2>&1 | grep -q UNIQUE
then
    echo -e "TEST UNIQUE:\tOK"
else
    echo -e "TEST UNIQUE:\tFAILED"
fi


if cat test/test_concat.sql | $SKDB | grep -q hellohello
then
    echo -e "TEST CONCAT:\tOK"
else
    echo -e "TEST CONCAT:\tFAILED"
fi

if cat test/test_notnull.sql | $SKDB 2>&1 | grep -q NULL
then
    echo -e "TEST NOT NULL:\tOK"
else
    echo -e "TEST NOT NULL:\tFAILED"
fi

if cat test/test_delete.sql | $SKDB | grep -v -q 22
then
    echo -e "TEST DELETE:\tOK"
else
    echo -e "TEST DELETE:\tFAILED"
fi

cat test/test_like.sql | $SKDB > /tmp/kk1
diff /tmp/kk1 test/unit/test_like.expected > /dev/null

if [ $? -eq 0 ]; then
    echo -e "TEST LIKE:\tOK"
else
    echo -e "TEST LIKE:\tFAILED"
fi

if cat test/join_select_order.sql | $SKDB --always-allow-joins | grep -q '4|6|4|4|1|4'
then
    echo -e "TEST JOIN ORDER:\tOK"
else
    echo -e "TEST JOIN ORDER:\tFAILED"
fi

if cat test/test_update.sql | $SKDB | grep -q '2|3'
then
    echo -e "TEST JOIN ORDER:\tOK"
else
    echo -e "TEST JOIN ORDER:\tFAILED"
fi

if cat test/primary_index.sql | $SKDB --show-used-indexes | grep -q 'USING INDEX: t1_id'
then
    echo -e "TEST PRIMARY INDEX:\tOK"
else
    echo -e "TEST PRIMARY INDEX:\tFAILED"
fi

if cat test/insert_values.sql | $SKDB | grep -q '3'
then
    echo -e "TEST MULTIPLE INSERTS:\tOK"
else
    echo -e "TEST MULTIPLE INSERTS:\tFAILED"
fi

if cat test/test_not_like.sql | $SKDB | grep -q 'def'
then
    echo -e "TEST NOT LIKE:\tOK"
else
    echo -e "TEST NOT LIKE:\tFAILED"
fi

if cat test/aggr_union.sql | $SKDB | awk '{x+=$1}; END {print x}' | grep -q '11'
then
    echo -e "TEST AGGR UNION:\tOK"
else
    echo -e "TEST AGGR UNION:\tFAILED"
fi

if cat test/unit/test_joins.sql | $SKDB --always-allow-joins | tr '\n' S | grep -q '1|2|1|3S2|4||S1|2|1|3S1|2|1|3S2|4||S'
then
    echo -e "TEST JOIN:\tOK"
else
    echo -e "TEST JOIN:\tFAILED"
fi

if cat test/unit_parse_float.sql | $SKDB | tr '\n' S | grep -q '1000000000.0S10000000000.0S100000000000000.0S1.0e+15S1.0e-05S1.1e-05S9.0e-05S0.0001S0.0009S58.0S400.0S1.23456e-65S1000.0S-100000000000000.0S-1.0e+15S-0.0001S-1.0e-05S-1.0e-09S-1.0e-10S-58.0S-400.0S-1.23456e-65S-1000.0S1.0e+15S100000000000000.0S1000.0S400.0S58.0S0.0009S0.0001S0.0001S9.0e-05S1.1e-05S1.0e-05S1.0e-05S1.23456e-65S-1.23456e-65S-1.0e-09S-1.0e-08S-1.0e-05S-0.0001S-58.0S-400.0S-1000.0S-100000000000000.0S-1.0e+15'
then
    echo -e "TEST PARSE FLOAT:\tOK"
else
    echo -e "TEST PARSE FLOAT:\tFAILED"
fi

gcc test/unit/utf8_string/make_utf8_insert_select.c -o /tmp/make_utf8_insert_select
/tmp/make_utf8_insert_select | $SKDB > /tmp/kk1

diff /tmp/kk1 test/unit/utf8_string/expected_string.txt > /dev/null

if [ $? -eq 0 ]; then
    echo -e "TEST UTF8:\tOK"
else
    echo -e "TEST UTF8:\tFAILED"
fi

./test_notify.sh

cat test/join_outside_of_virtual.sql | $SKDB 2> /tmp/kk1
diff /tmp/kk1 test/unit/join_outside_of_virtual.exp > /dev/null

if [ $? -eq 0 ]; then
    echo -e "TEST VIRTUAL JOIN:\tOK"
else
    echo -e "TEST VIRTUAL JOIN:\tFAILED"
fi

if cat test/insert_autoid.sql | $SKDB | grep -q "3"
then
    echo -e "TEST INSERT AUTOINCREMENT:\tOK"
else
    echo -e "TEST INSERT AUTOINCREMENT:\tFAILED"
fi

if cat test/unit/test_id.sql | $SKDB | tr '\n' S | grep -q "123S122S"; then
    echo -e "TEST ID:\tOK"
else
    echo -e "TEST ID:\tFAILED"
fi

if cat test/lower_upper.sql | $SKDB | grep -q "FOO|bar"; then
    echo -e "TEST LOWER/UPPER:\tOK"
else
    echo -e "TEST LOWER/UPPER:\tFAILED"
fi

if cat test/unit/test_insert_id.sql | $SKDB | grep -q "|22"; then
    echo -e "TEST INSERT ID:\tOK"
else
    echo -e "TEST INSERT ID:\tFAILED"
fi


if cat test/test_string_escaping_json.sql | $SKDB --format=json | grep -q '{"a":"\\"Hello world\\""}'; then
    echo -e "TEST STRING ESCAPING JSON:\tOK"
else
    echo -e "TEST STRING ESCAPING JSON:\tFAILED"
fi

if cat test/test_null_encoding_json.sql | $SKDB --format=json | grep -q '{"a":1,"b":null,"c":2}'; then
    echo -e "TEST NULL ENCODING JSON:\tOK"
else
    echo -e "TEST NULL ENCODING JSON:\tFAILED"
fi

if cat test/test_real.sql | $SKDB | grep -q "1"; then
    echo -e "TEST REAL:\tOK"
else
    echo -e "TEST REAL:\tFAILED"
fi

if cat test/test_missing_semi.sql | $SKDB | grep -q "22"; then
    echo -e "TEST MISSING SEMI:\tOK"
else
    echo -e "TEST MISSING SEMI:\tFAILED"
fi

if cat test/test_ignore_replace.sql | $SKDB | tr '\n' 'S' | grep -q "22|23S24|26S25|27S31|32S33|34S51|42|43S"; then
    echo -e "TEST IGNORE/REPLACE:\tOK"
else
    echo -e "TEST IGNORE/REPLACE:\tFAILED"
fi

if cat test/test_ignore_replace2.sql | $SKDB | tr '\n' 'S' | grep -q "50|1S50|2S"; then
    echo -e "TEST IGNORE/REPLACE2:\tOK"
else
    echo -e "TEST IGNORE/REPLACE2:\tFAILED"
fi

if cat test/test_underscore_alias.sql | $SKDB | grep -q "22"; then
    echo -e "TEST UNDERSCORE ALIAS:\tOK"
else
    echo -e "TEST UNDERSCORE ALIAS:\tFAILED"
fi

if cat test/create_index_if_not_exists.sql | $SKDB | grep -q "22"; then
    echo -e "CREATE INDEX IF NOT EXISTS:\tOK"
else
    echo -e "CREATE INDEX IF NOT EXISTS:\tFAILED"
fi

tmpfile=$(mktemp /tmp/testfile.XXXXXX)
tmpfile_dump=$(mktemp /tmp/testfile.XXXXXX)
rm -f $tmpfile $tmpfile_dump
$SKDB --init $tmpfile
cat test/unit/test_dump_index.sql | $SKDB --data $tmpfile
$SKDB dump --data $tmpfile > $tmpfile_dump

diff $tmpfile_dump test/unit/test_dump_index.exp  > /dev/null
if [ $? -eq 0 ]; then
    rm $tmpfile $tmpfile_dump
    echo -e "TEST DUMP INDEXES:\tOK"
else
    echo -e "TEST DUMP INDEXES:\tFAILED"
fi

if cat test/test_select_star_plus.sql | $SKDB | grep -q "22|23|45"; then
    echo -e "TEST STAR COMMA:\tOK"
else
    echo -e "TEST STAR COMMA:\tFAILED"
fi

if cat test/unit/test_default_values.sql | $SKDB | tr '\n' 'S' | grep -q "14|test1|test2S20||fooS24|bar|helloS"; then
    echo -e "TEST DEFAULT VALUES:\tOK"
else
    echo -e "TEST DEFAULT VALUES:\tFAILED"
fi

if cat test/test_count_string.sql | $SKDB | grep -q "0"; then
    echo -e "TEST COUNT STRING:\tOK"
else
    echo -e "TEST COUNT STRING:\tFAILED"
fi

if cat test/test_insert_or_update.sql | $SKDB | grep -q "1|3"; then
    echo -e "TEST INSERT OR UPDATE:\tOK"
else
    echo -e "TEST INSERT OR UPDATE:\tFAILED"
fi

if cat test/test_table_dot_star.sql | $SKDB --always-allow-joins | grep -q "2|3|4|5|2|6"; then
    echo -e "TEST DOT STAR:\tOK"
else
    echo -e "TEST DOT STAR:\tFAILED"
fi

if cat test/unit/test_index_on_star.sql | $SKDB --show-used-indexes | grep -q "USING INDEX: v1_a"; then
    echo -e "TEST INDEX DOT STAR:\tOK"
else
    echo -e "TEST INDEX DOT STAR:\tFAILED"
fi

if cat test/limit_unit.sql | $SKDB | wc | tr ' ' 'S' | tr '\n' 'S' | grep -q "SSSSSS1SSSSSSS1SSSSSSS2S"; then
    echo -e "TEST LIMIT:\tOK"
else
    echo -e "TEST LIMIT:\tFAILED"
fi

if cat test/test_index_transaction.sql | $SKDB --show-used-indexes | tr ' ' 'S' | grep -q "USINGSINDEX:ST1_a"; then
    echo -e "TEST TRANSACTION INDEX:\tOK"
else
    echo -e "TEST TRANSACTION INDEX:\tFAILED"
fi

if cat test/test_index_transaction2.sql | $SKDB --show-used-indexes | tr ' ' 'S' | grep -q "USINGSINDEX:ST1_a"; then
    echo -e "TEST TRANSACTION INDEX 2:\tOK"
else
    echo -e "TEST TRANSACTION INDEX 2:\tFAILED"
fi
