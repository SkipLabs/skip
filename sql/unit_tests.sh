#!/bin/bash

if cat test/test_unique.sql | ../build/sqlive 2>&1 | grep -q UNIQUE
then
    echo -e "TEST UNIQUE:\tOK"
else
    echo -e "TEST UNIQUE:\tFAILED"
fi


if cat test/test_concat.sql | ../build/sqlive | grep -q hellohello
then
    echo -e "TEST CONCAT:\tOK"
else
    echo -e "TEST CONCAT:\tFAILED"
fi

if cat test/test_notnull.sql | ../build/sqlive 2>&1 | grep -q NULL
then
    echo -e "TEST NOT NULL:\tOK"
else
    echo -e "TEST NOT NULL:\tFAILED"
fi

if cat test/test_delete.sql | ../build/sqlive | grep -v -q 22
then
    echo -e "TEST DELETE:\tOK"
else
    echo -e "TEST DELETE:\tFAILED"
fi

cat test/test_like.sql | ../build/sqlive > /tmp/kk1
diff /tmp/kk1 test/test_like.expected > /dev/null

if [ $? -eq 0 ]; then
    echo -e "TEST LIKE:\tOK"
else
    echo -e "TEST LIKE:\tFAILED"
fi

if cat test/join_select_order.sql | ../build/sqlive --always-allow-joins | grep -q '4|6|4|4|1|4'
then
    echo -e "TEST JOIN ORDER:\tOK"
else
    echo -e "TEST JOIN ORDER:\tFAILED"
fi

if cat test/test_update.sql | ../build/sqlive | grep -q '2|3'
then
    echo -e "TEST JOIN ORDER:\tOK"
else
    echo -e "TEST JOIN ORDER:\tFAILED"
fi

if cat test/primary_index.sql | sqlive --show-used-indexes | grep -q 'USING INDEX: t1_id'
then
    echo -e "TEST PRIMARY INDEX:\tOK"
else
    echo -e "TEST PRIMARY INDEX:\tFAILED"
fi

if cat test/insert_values.sql | sqlive | grep -q '3'
then
    echo -e "TEST MULTIPLE INSERTS:\tOK"
else
    echo -e "TEST MULTIPLE INSERTS:\tFAILED"
fi

if cat test/test_not_like.sql | sqlive | grep -q 'def'
then
    echo -e "TEST NOT LIKE:\tOK"
else
    echo -e "TEST NOT LIKE:\tFAILED"
fi

if cat test/aggr_union.sql | sqlive | awk -P '{x+=$1}; END {print x}' | grep -q '11'
then
    echo -e "TEST AGGR UNION:\tOK"
else
    echo -e "TEST AGGR UNION:\tFAILED"
fi

if cat test/test_joins.sql | sqlive --always-allow-joins | tr '\n' S | grep -q '1|2|1|3S2|4||S||1|3S1|2|1|3S||1|3S1|2|1|3S2|4||S'
then
    echo -e "TEST JOIN:\tOK"
else
    echo -e "TEST JOIN:\tFAILED"
fi

if cat test/unit_parse_float.sql | sqlive | tr '\n' S | grep -q '100000000000000.0S58.0S400.0S1.2345600000000001e-65S1000.0S-100000000000000.0S-58.0S-400.0S-1.2345600000000001e-65S-1000.0S-100000000000000.0S-1000.0S-400.0S-58.0S-1.2345600000000001e-65S1.2345600000000001e-65S58.0S400.0S1000.0S100000000000000.0'
then
    echo -e "TEST PARSE FLOAT:\tOK"
else
    echo -e "TEST PARSE FLOAT:\tFAILED"
fi

gcc test/utf8_string/make_utf8_insert_select.c -o /tmp/make_utf8_insert_select
/tmp/make_utf8_insert_select | sqlive > /tmp/kk1

diff /tmp/kk1 test/utf8_string/expected_string.txt > /dev/null

if [ $? -eq 0 ]; then
    echo -e "TEST UTF8:\tOK"
else
    echo -e "TEST UTF8:\tFAILED"
fi

./test_notify.sh

cat test/join_outside_of_virtual.sql | sqlive 2> /tmp/kk1
diff /tmp/kk1 test/join_outside_of_virtual.exp > /dev/null

if [ $? -eq 0 ]; then
    echo -e "TEST VIRTUAL JOIN:\tOK"
else
    echo -e "TEST VIRTUAL JOIN:\tFAILED"
fi

if cat test/insert_autoid.sql | sqlive | grep -q "3"
then
    echo -e "TEST INSERT AUTOINCREMENT:\tOK"
else
    echo -e "TEST INSERT AUTOINCREMENT:\tFAILED"
fi

if cat test/test_id.sql | sqlive | tr '\n' S | grep -q "123S122S"; then
    echo -e "TEST ID:\tOK"
else
    echo -e "TEST ID:\tFAILED"
fi

if cat test/lower_upper.sql | sqlive | grep -q "FOO|bar"; then
    echo -e "TEST LOWER/UPPER:\tOK"
else
    echo -e "TEST LOWER/UPPER:\tFAILED"
fi
