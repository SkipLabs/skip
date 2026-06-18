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

# Hardcoded extra services
declare -A EXTRA_SERVICES
EXTRA_SERVICES[remote]="sum"

# Directories
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXAMPLES_DIR="$SCRIPT_DIR/../../../examples"
REF_DIR="$SCRIPT_DIR/.."

# Auto-discover examples from the reference outputs in REF_DIR, mirroring the Node side
ALL_EXAMPLES=()
for exp in "$REF_DIR"/*.exp.out; do
    [ -e "$exp" ] || continue
    base="$(basename "$exp" .exp.out)"
    ALL_EXAMPLES+=("$base")
done

# Run the example processes from EXAMPLES_DIR so files created relative to the
# cwd (e.g. db.sqlite) land where the examples' .gitignore
# covers them, matching the Node scripts that cd into examples/ first.
cd "$EXAMPLES_DIR" || exit 1

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

# Poll a local TCP port until it accepts a connection, returns 1 if the port is not up within the timeout.
wait_for_port() {
    local port="$1"
    local i=0
    while [ "$i" -lt 10 ]; do
        if (exec 3<>"/dev/tcp/localhost/${port}") 2>/dev/null; then
            exec 3>&- 3<&-
            return 0
        fi
        sleep 1
        i=$((i + 1))
    done
    return 1
}

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
        # Client talks to the REST server; wait until it listens instead of
        # racing it.
        if ! wait_for_port 8082; then
            echo "  [FAIL] timed out waiting for server port 8082"
            cleanup
            return 1
        fi
    else
        sleep 3
    fi

    bun run "$EXAMPLES_DIR/${name}-client.ts" >"$out_file" 2>"$err_file"
    local client_status=$?

    cleanup

    # Compare outputs (with .exp.out.alt fallback if present)
    local fail=0
    if [ "$client_status" -ne 0 ]; then
        echo "  [FAIL] client exited with status $client_status"
        fail=1
    fi
    echo "diff $out_file $exp_out"
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

    echo "diff $err_file $exp_err"
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
