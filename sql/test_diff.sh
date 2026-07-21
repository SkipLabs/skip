#!/bin/bash

if [ -z "$SKDB_BIN" ]; then
    if [ -z "$SKARGO_PROFILE" ]; then
        SKARGO_PROFILE=dev
    fi
    SKDB_BIN="skargo run -q --profile $SKARGO_PROFILE -- "
fi

export SKDB_CMD=$SKDB_BIN

pass() { printf "%-55s OK\n" "$1:"; }
fail() { printf "%-55s FAILED\n" "$1:"; }

set -o pipefail

run_diff () {
    test_id=$1
    shift
    use_sqlite=true
    if [ "$1" = "--no-sqlite" ]; then
        use_sqlite=false
        shift
    fi
    creation_script=$1
    shift
    views_script=$1
    shift
    more_scripts=("$@")

    TMP_DIR=skdb.test_diff.$test_id
    mkdir -p "$TMP_DIR"
    # shellcheck disable=SC2064 # Intended immediate expansion
    trap "rm -rf '$TMP_DIR'" EXIT

    DB="$TMP_DIR/db"
    SKDB="$SKDB_CMD --always-allow-joins --data $DB"

    nviews=$(cat "$views_script" | grep VIEW | sed 's/CREATE REACTIVE VIEW V//' | sed 's/ .*//' | sort -n -r | head -n 1)

    $SKDB_CMD --init "$DB"
    cat "$creation_script" "$views_script" | $SKDB
    if [ $? -ne 0 ]; then
        fail "$test_id - $views_script (creation)"
    fi

    for i in $(seq 0 $((nviews))); do
        $SKDB subscribe "V$i" --connect --updates "$TMP_DIR/V$i" > /dev/null &
    done

    wait

    cat "${more_scripts[@]}" | $SKDB
    if [ $? -ne 0 ]; then
        fail "$test_id - $views_script (inserts)"
    fi

    for i in $(seq 0 $((nviews))); do
        echo "select * from V$i;"
    done > "$TMP_DIR/selects.sql";

    wait

    for i in $(seq 0 $((nviews))); do
        cat "$TMP_DIR/V$i" | $SKDB_CMD replay >> "$TMP_DIR/replays"
    done;

    cat "$TMP_DIR/selects.sql" | $SKDB | sort -n > "$TMP_DIR/kk1"
    if [ $? -ne 0 ]; then
        fail "$test_id - $views_script (selects)"
    fi

    if $use_sqlite; then
        cat "$views_script" | sed 's/CREATE REACTIVE VIEW V[0-9]* AS //' > "$TMP_DIR/selects2.sql"

        cat "$creation_script" "${more_scripts[@]}" "$TMP_DIR/selects2.sql" | sqlite3 | sort -n > "$TMP_DIR/kk2"

        diff "$TMP_DIR/kk1" "$TMP_DIR/kk2"
        if [ $? -eq 0 ]; then
            pass "$test_id - $views_script (part-1)"
        else
            fail "$test_id - $views_script (part-1)"
        fi
    fi

    cat "$TMP_DIR/replays" | sort -n > "$TMP_DIR/kk3"

    diff "$TMP_DIR/kk1" "$TMP_DIR/kk3" > /dev/null
    if [ $? -eq 0 ]; then
        pass "$test_id - $views_script (part-2)"
    else
        fail "$test_id - $views_script (part-2)"
    fi
}

export -f run_diff pass fail

MAXIMUM_RESIDENT_SET_SIZE_MB=700
LIMITING=(--memsuspend "${MAXIMUM_RESIDENT_SET_SIZE_MB}M" --memfree "${MAXIMUM_RESIDENT_SET_SIZE_MB}M")
if ${CIRCLECI:-false}; then
    LIMITING+=(--jobs 8)
fi

parallel "${LIMITING[@]}" --colsep ' ' run_diff <<END
01 test/diff/select2_create.sql test/diff/select2_min_views.sql test/diff/select2_inserts.sql
02 test/diff/select2_create.sql test/diff/select2_min_views.sql test/diff/select2_inserts.sql test/diff/select2_deletes.sql
03 test/diff/select2_create.sql test/diff/select2_min_views.sql test/diff/select2_inserts.sql test/diff/select2_deletes.sql test/diff/select2_inserts.sql
04 test/diff/select1_create.sql test/diff/select1_views.sql test/diff/select1_inserts.sql
05 test/diff/select1_float_create.sql test/diff/select1_float_views.sql test/diff/select1_float_inserts.sql
06 test/diff/select2_create.sql test/diff/select2_views.sql test/diff/select2_inserts.sql
07 test/diff/select3_create.sql test/diff/select3_views.sql test/diff/select3_inserts.sql
08 test/diff/select3_create.sql test/diff/select3_views.sql test/diff/select3_inserts.sql test/diff/select3_partial_delete.sql
09 test/diff/select4.1-create.sql test/diff/select4.1-views.sql test/diff/select4.1-inserts.sql
10 test/diff/select5.1-create.sql test/diff/select5.1-views.sql test/diff/select5.1-inserts.sql
11 test/diff/groupby_create.sql test/diff/groupby_views.sql test/diff/groupby_inserts.sql
12 test/diff/groupby_create.sql test/diff/groupby_views.sql test/diff/groupby_inserts.sql test/diff/groupby_delete.sql
13 test/diff/slt_good_0_create.sql test/diff/slt_good_0_views.sql test/diff/slt_good_0_inserts.sql
14 --no-sqlite test/diff/select2_create.sql test/diff/select2_min_views_limit1.sql test/diff/select2_inserts.sql
15 --no-sqlite test/diff/select2_create.sql test/diff/select2_min_views_limit1.sql test/diff/select2_inserts.sql test/diff/select2_deletes.sql
16 --no-sqlite test/diff/select2_create.sql test/diff/select2_min_views_limit1.sql test/diff/select2_inserts.sql test/diff/select2_deletes.sql test/diff/select2_inserts.sql
17 --no-sqlite test/diff/select1_create.sql test/diff/select1_views_limit1.sql test/diff/select1_inserts.sql
18 --no-sqlite test/diff/select1_float_create.sql test/diff/select1_float_views_limit1.sql test/diff/select1_float_inserts.sql
19 --no-sqlite test/diff/select2_create.sql test/diff/select2_views_limit1.sql test/diff/select2_inserts.sql
20 --no-sqlite test/diff/select3_create.sql test/diff/select3_views_limit1.sql test/diff/select3_inserts.sql
21 --no-sqlite test/diff/select3_create.sql test/diff/select3_views_limit1.sql test/diff/select3_inserts.sql test/diff/select3_partial_delete.sql
22 --no-sqlite test/diff/select4.1-create.sql test/diff/select4.1-views_limit1.sql test/diff/select4.1-inserts.sql
23 --no-sqlite test/diff/select5.1-create.sql test/diff/select5.1-views_limit1.sql test/diff/select5.1-inserts.sql
24 --no-sqlite test/diff/groupby_create.sql test/diff/groupby_views_limit1.sql test/diff/groupby_inserts.sql
25 --no-sqlite test/diff/groupby_create.sql test/diff/groupby_views_limit1.sql test/diff/groupby_inserts.sql test/diff/groupby_delete.sql
26 --no-sqlite test/diff/slt_good_0_create.sql test/diff/slt_good_0_views_limit1.sql test/diff/slt_good_0_inserts.sql
27 --no-sqlite test/diff/select2_create.sql test/diff/select2_min_views_limit5.sql test/diff/select2_inserts.sql
28 --no-sqlite test/diff/select2_create.sql test/diff/select2_min_views_limit5.sql test/diff/select2_inserts.sql test/diff/select2_deletes.sql
29 --no-sqlite test/diff/select2_create.sql test/diff/select2_min_views_limit5.sql test/diff/select2_inserts.sql test/diff/select2_deletes.sql test/diff/select2_inserts.sql
30 --no-sqlite test/diff/select1_create.sql test/diff/select1_views_limit5.sql test/diff/select1_inserts.sql
31 --no-sqlite test/diff/select1_float_create.sql test/diff/select1_float_views_limit5.sql test/diff/select1_float_inserts.sql
32 --no-sqlite test/diff/select2_create.sql test/diff/select2_views_limit5.sql test/diff/select2_inserts.sql
33 --no-sqlite test/diff/select3_create.sql test/diff/select3_views_limit5.sql test/diff/select3_inserts.sql
34 --no-sqlite test/diff/select3_create.sql test/diff/select3_views_limit5.sql test/diff/select3_inserts.sql test/diff/select3_partial_delete.sql
35 --no-sqlite test/diff/select4.1-create.sql test/diff/select4.1-views_limit5.sql test/diff/select4.1-inserts.sql
36 --no-sqlite test/diff/select5.1-create.sql test/diff/select5.1-views_limit5.sql test/diff/select5.1-inserts.sql
37 --no-sqlite test/diff/groupby_create.sql test/diff/groupby_views_limit5.sql test/diff/groupby_inserts.sql
38 --no-sqlite test/diff/groupby_create.sql test/diff/groupby_views_limit5.sql test/diff/groupby_inserts.sql test/diff/groupby_delete.sql
39 --no-sqlite test/diff/slt_good_0_create.sql test/diff/slt_good_0_views_limit5.sql test/diff/slt_good_0_inserts.sql
END