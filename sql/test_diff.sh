#!/bin/bash

if [ -z "$SKARGO_PROFILE" ]; then
    SKARGO_PROFILE=dev
fi

SKDB_CMD="skargo run -q --profile $SKARGO_PROFILE -- "

pass() { printf "%-50s OK\n" "$1:"; }
fail() { printf "%-50s FAILED\n" "$1:"; }

run_diff () {
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

    TMP_DIR=$(mktemp -t --directory skdb.test_diff.XXXXXXXX)
    # shellcheck disable=SC2064 # Intended immediate expansion
    trap "rm -rf '$TMP_DIR'" EXIT

    DB="$TMP_DIR/db"
    SKDB="$SKDB_CMD --always-allow-joins --data $DB"

    nviews=$(cat "$views_script" | grep VIEW | sed 's/CREATE REACTIVE VIEW V//' | sed 's/ .*//' | sort -n -r | head -n 1)

    $SKDB_CMD --init "$DB"
    cat "$creation_script" "$views_script" | $SKDB

    for i in $(seq 0 $((nviews))); do
        $SKDB subscribe "V$i" --connect --updates "$TMP_DIR/V$i" > /dev/null &
    done

    wait

    cat "${more_scripts[@]}" | $SKDB

    for i in $(seq 0 $((nviews))); do
        echo "select * from V$i;"
    done > "$TMP_DIR/selects.sql";

    wait

    for i in $(seq 0 $((nviews))); do
        cat "$TMP_DIR/V$i" | $SKDB_CMD replay >> "$TMP_DIR/replays"
    done;

    cat "$TMP_DIR/selects.sql" | $SKDB | sort -n > "$TMP_DIR/kk1"

    if $use_sqlite; then
        cat "$views_script" | sed 's/CREATE REACTIVE VIEW V[0-9]* AS //' > "$TMP_DIR/selects2.sql"

        cat "$creation_script" "${more_scripts[@]}" "$TMP_DIR/selects2.sql" | sqlite3 | sort -n > "$TMP_DIR/kk2"

        diff "$TMP_DIR/kk1" "$TMP_DIR/kk2"
        if [ $? -eq 0 ]; then
            pass "$views_script (part-1)"
        else
            fail "$views_script (part-1)"
        fi
    fi

    cat "$TMP_DIR/replays" | sort -n > "$TMP_DIR/kk3"

    diff "$TMP_DIR/kk1" "$TMP_DIR/kk3" > /dev/null
    if [ $? -eq 0 ]; then
        pass "$views_script (part-2)"
    else
        fail "$views_script (part-2)"
    fi

}

run_diff 'test/diff/select2_create.sql' 'test/diff/select2_min_views.sql' 'test/diff/select2_inserts.sql'
run_diff 'test/diff/select2_create.sql' 'test/diff/select2_min_views.sql' 'test/diff/select2_inserts.sql' 'test/diff/select2_deletes.sql'
run_diff 'test/diff/select2_create.sql' 'test/diff/select2_min_views.sql' 'test/diff/select2_inserts.sql' 'test/diff/select2_deletes.sql' 'test/diff/select2_inserts.sql'
run_diff 'test/diff/select1_create.sql' 'test/diff/select1_views.sql' 'test/diff/select1_inserts.sql'
run_diff 'test/diff/select1_float_create.sql' 'test/diff/select1_float_views.sql' 'test/diff/select1_float_inserts.sql'
run_diff 'test/diff/select2_create.sql' 'test/diff/select2_views.sql' 'test/diff/select2_inserts.sql'
run_diff 'test/diff/select3_create.sql' 'test/diff/select3_views.sql' 'test/diff/select3_inserts.sql'
run_diff 'test/diff/select3_create.sql' 'test/diff/select3_views.sql' 'test/diff/select3_inserts.sql' 'test/diff/select3_partial_delete.sql'
run_diff 'test/diff/select4.1-create.sql' 'test/diff/select4.1-views.sql' 'test/diff/select4.1-inserts.sql'
run_diff 'test/diff/select5.1-create.sql' 'test/diff/select5.1-views.sql' 'test/diff/select5.1-inserts.sql'
run_diff 'test/diff/groupby_create.sql' 'test/diff/groupby_views.sql' 'test/diff/groupby_inserts.sql'
run_diff 'test/diff/groupby_create.sql' 'test/diff/groupby_views.sql' 'test/diff/groupby_inserts.sql' 'test/diff/groupby_delete.sql'
run_diff 'test/diff/slt_good_0_create.sql' 'test/diff/slt_good_0_views.sql' 'test/diff/slt_good_0_inserts.sql'

# Same tests, but with a limit of 1

run_diff --no-sqlite 'test/diff/select2_create.sql' 'test/diff/select2_min_views_limit1.sql' 'test/diff/select2_inserts.sql'
run_diff --no-sqlite 'test/diff/select2_create.sql' 'test/diff/select2_min_views_limit1.sql' 'test/diff/select2_inserts.sql' 'test/diff/select2_deletes.sql'
run_diff --no-sqlite 'test/diff/select2_create.sql' 'test/diff/select2_min_views_limit1.sql' 'test/diff/select2_inserts.sql' 'test/diff/select2_deletes.sql' 'test/diff/select2_inserts.sql'
run_diff --no-sqlite 'test/diff/select1_create.sql' 'test/diff/select1_views_limit1.sql' 'test/diff/select1_inserts.sql'
run_diff --no-sqlite 'test/diff/select1_float_create.sql' 'test/diff/select1_float_views_limit1.sql' 'test/diff/select1_float_inserts.sql'
run_diff --no-sqlite 'test/diff/select2_create.sql' 'test/diff/select2_views_limit1.sql' 'test/diff/select2_inserts.sql'
run_diff --no-sqlite 'test/diff/select3_create.sql' 'test/diff/select3_views_limit1.sql' 'test/diff/select3_inserts.sql'
run_diff --no-sqlite 'test/diff/select3_create.sql' 'test/diff/select3_views_limit1.sql' 'test/diff/select3_inserts.sql' 'test/diff/select3_partial_delete.sql'
run_diff --no-sqlite 'test/diff/select4.1-create.sql' 'test/diff/select4.1-views_limit1.sql' 'test/diff/select4.1-inserts.sql'
run_diff --no-sqlite 'test/diff/select5.1-create.sql' 'test/diff/select5.1-views_limit1.sql' 'test/diff/select5.1-inserts.sql'
run_diff --no-sqlite 'test/diff/groupby_create.sql' 'test/diff/groupby_views_limit1.sql' 'test/diff/groupby_inserts.sql'
run_diff --no-sqlite 'test/diff/groupby_create.sql' 'test/diff/groupby_views_limit1.sql' 'test/diff/groupby_inserts.sql' 'test/diff/groupby_delete.sql'
run_diff --no-sqlite 'test/diff/slt_good_0_create.sql' 'test/diff/slt_good_0_views_limit1.sql' 'test/diff/slt_good_0_inserts.sql'

# Same tests, but with a limit of 5

run_diff --no-sqlite 'test/diff/select2_create.sql' 'test/diff/select2_min_views_limit5.sql' 'test/diff/select2_inserts.sql'
run_diff --no-sqlite 'test/diff/select2_create.sql' 'test/diff/select2_min_views_limit5.sql' 'test/diff/select2_inserts.sql' 'test/diff/select2_deletes.sql'
run_diff --no-sqlite 'test/diff/select2_create.sql' 'test/diff/select2_min_views_limit5.sql' 'test/diff/select2_inserts.sql' 'test/diff/select2_deletes.sql' 'test/diff/select2_inserts.sql'
run_diff --no-sqlite 'test/diff/select1_create.sql' 'test/diff/select1_views_limit5.sql' 'test/diff/select1_inserts.sql'
run_diff --no-sqlite 'test/diff/select1_float_create.sql' 'test/diff/select1_float_views_limit5.sql' 'test/diff/select1_float_inserts.sql'
run_diff --no-sqlite 'test/diff/select2_create.sql' 'test/diff/select2_views_limit5.sql' 'test/diff/select2_inserts.sql'
run_diff --no-sqlite 'test/diff/select3_create.sql' 'test/diff/select3_views_limit5.sql' 'test/diff/select3_inserts.sql'
run_diff --no-sqlite 'test/diff/select3_create.sql' 'test/diff/select3_views_limit5.sql' 'test/diff/select3_inserts.sql' 'test/diff/select3_partial_delete.sql'
run_diff --no-sqlite 'test/diff/select4.1-create.sql' 'test/diff/select4.1-views_limit5.sql' 'test/diff/select4.1-inserts.sql'
run_diff --no-sqlite 'test/diff/select5.1-create.sql' 'test/diff/select5.1-views_limit5.sql' 'test/diff/select5.1-inserts.sql'
run_diff --no-sqlite 'test/diff/groupby_create.sql' 'test/diff/groupby_views_limit5.sql' 'test/diff/groupby_inserts.sql'
run_diff --no-sqlite 'test/diff/groupby_create.sql' 'test/diff/groupby_views_limit5.sql' 'test/diff/groupby_inserts.sql' 'test/diff/groupby_delete.sql'
run_diff --no-sqlite 'test/diff/slt_good_0_create.sql' 'test/diff/slt_good_0_views_limit5.sql' 'test/diff/slt_good_0_inserts.sql'
