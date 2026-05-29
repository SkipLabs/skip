#!/bin/bash
# run_examples.sh
# Start testing examples on Bun, the same way it does for Node, but in src ts directly
#
# Usage:
#   ./run_examples.sh              # Start all examples
#   ./run_examples.sh sum          # Start `sum` example only
#   ./run_examples.sh sum remote   # Start `sum` and `remote`
#
# For each example, the script
#   - Starts principal service <name>.ts
#   - Starts the additional server service <name>-server.ts if it exists
#   - Starts potential additionnal hardocded service (like for remote) (cf EXTRA_SERVICES)
#   - Starts client <name>-client.ts and redirect its stderr/stdout
#   - Compare reference files .exp.out / .exp.err with actual example outputs
#   - Show the diff if fails, but continue to try the other examples

ALL_EXAMPLES=(
    sum
    database
    departures
    groups
    remote
    sheet
)

# Hardcoded extra services : EXTRA_SERVICES[<example>]="service1 service2 ..."
declare -A EXTRA_SERVICES
EXTRA_SERVICES[remote]="sum"

# Directories
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXAMPLES_DIR="$SCRIPT_DIR/../../../examples"
REF_DIR="$SCRIPT_DIR/.."

# List of background PID's to clean later
BG_PIDS=()

cleanup() {
    if [ ${#BG_PIDS[@]} -gt 0 ]; then
        kill "${BG_PIDS[@]}" 2>/dev/null
        wait "${BG_PIDS[@]}" 2>/dev/null
    fi
    BG_PIDS=()
}

# Cleanup if Ctrl+C or abnormal exit
trap cleanup EXIT INT TERM

run_one_example() {
    local name="$1"
    local out_file="/tmp/${name}-bun.out"
    local err_file="/tmp/${name}-bun.err"
    local exp_out="$REF_DIR/${name}.exp.out"
    local exp_err="$REF_DIR/${name}.exp.err"

    echo "Running '${name}' example on @skipruntime/native (bun, src mode)"

    local extras="${EXTRA_SERVICES[$name]:-}"
    for extra in $extras; do
        SKIP_PLATFORM="native" bun run "$EXAMPLES_DIR/${extra}.ts" >/dev/null &
        BG_PIDS+=($!)
    done
    SKIP_PLATFORM="native" bun run "$EXAMPLES_DIR/${name}.ts" >/dev/null &
    BG_PIDS+=($!)
    if [ -f "$EXAMPLES_DIR/${name}-server.ts" ]; then
        bun run "$EXAMPLES_DIR/${name}-server.ts" >/dev/null &
        BG_PIDS+=($!)
    fi
    sleep 1
#    if [ "$name" = "remote" ]; then
#        sleep 2
#    fi
    bun run "$EXAMPLES_DIR/${name}-client.ts" >"$out_file" 2>"$err_file"
    cleanup
    # Compare outputs (with .exp.out.alt fallback if present)
    local fail=0

    if ! diff "$out_file" "$exp_out" >/dev/null 2>&1; then
        # Main diff failed, try the .alt fallback
        if [ -e "${exp_out}.alt" ] && diff "$out_file" "${exp_out}.alt" >/dev/null 2>&1; then
            : # match with alt version
        else
            diff "$out_file" "$exp_out"
            echo "  [FAIL] stdout differs from $exp_out"
            fail=1
        fi
    fi

    if ! diff "$err_file" "$exp_err"; then
        echo "  [FAIL] stderr differs from $exp_err"
        fail=1
    fi

    return $fail
}

if [ $# -eq 0 ]; then
    EXAMPLES=("${ALL_EXAMPLES[@]}")
else
    EXAMPLES=("$@")
fi

GLOBAL_FAIL=0
for example in "${EXAMPLES[@]}"; do
    if ! run_one_example "$example"; then
        GLOBAL_FAIL=1
    fi
done

exit $GLOBAL_FAIL
