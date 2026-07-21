#!/bin/bash
# Run `skargo test` for the current package (cwd), wrapped in `circleci tests
# run` under CircleCI so the "Rerun failed tests" button reruns only the test
# suites that failed. Invoke from the package directory. Reads from the env:
#   SKTEST_JUNIT  optional JUnit output path (forwarded as --junitxml)
#   SKTEST_JOBS   optional parallelism    (forwarded as --jobs)
#
# The failed suite names reach the unchanged `skargo test` via SKTEST_FILTERS
# (newline-separated), which the sktest harness reads; `skargo test --list`
# enumerates the suites -- the JUnit `classname` CircleCI keys reruns on, since
# sktest has no usable per-test source file.
set -euo pipefail

self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

args=()
[ -n "${SKTEST_JOBS:-}" ] && args+=(--jobs "$SKTEST_JOBS")
if [ -n "${SKTEST_JUNIT:-}" ]; then
    args+=(--junitxml "$SKTEST_JUNIT")
    mkdir -p "$(dirname "$SKTEST_JUNIT")"
    # The JUnit reporter appends; drop any stale report so a re-run (or a
    # multi-batch xargs) rewrites it cleanly instead of concatenating documents.
    rm -f "$SKTEST_JUNIT"
fi

if [ -z "${CIRCLECI:-}" ]; then
    # Local: run the whole suite directly.
    exec skargo test "${args[@]}"
fi

if [ "$#" -eq 0 ]; then
    # Orchestrator: enumerate suites (this also builds the test target once);
    # `circleci tests run` picks which to run -- all of them normally, only the
    # previously-failed ones on a rerun -- and re-invokes us with them as args.
    suites=$(skargo test --list)
    [ -n "$suites" ] || { echo "run-sktest.sh: no test suites found" >&2; exit 1; }
    # -r: an empty rerun set is a no-op. -d '\n': split only on newlines (suite
    # names are safe today, but this stops xargs word-splitting/quote-processing
    # them). Single-quote $self so it survives the shell re-parse inside
    # `circleci tests run`.
    printf '%s\n' "$suites" \
        | circleci tests run --command="xargs -r -d '\n' '$self'" --verbose
else
    # Inner: run only the given suites, passed to the harness via SKTEST_FILTERS.
    SKTEST_FILTERS=$(printf '%s\n' "$@")
    export SKTEST_FILTERS
    exec skargo test "${args[@]}"
fi
