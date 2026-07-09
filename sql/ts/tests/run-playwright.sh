#!/bin/bash
# Run the skdb wasm playwright test suite.
#
# In CircleCI (CIRCLECI is set) the suite is wrapped in `circleci tests run` so
# the "Rerun failed tests" button reruns only the spec files that failed, and a
# JUnit report is emitted for CircleCI to track failures. `circleci tests run`
# re-invokes this script with the (failed, on a rerun) spec files as arguments,
# taking the runner branch below. Everywhere else -- local `make test` -- we run
# the whole suite directly with the line reporter.
set -euo pipefail

cd "$(dirname "$0")" || exit 1
self="$PWD/$(basename "$0")"

if [ -n "${CIRCLECI:-}" ] && [ -z "${SKDB_WASM_TESTS_INNER:-}" ]; then
    # Orchestrator: let `circleci tests run` pick the specs (all of them
    # normally, only the previously-failed ones on a rerun).
    mkdir -p "$HOME/test-results"
    export SKDB_WASM_TESTS_INNER=1
    export PLAYWRIGHT_JUNIT_OUTPUT_NAME="$HOME/test-results/skdb-wasm.xml"
    # -r: an empty rerun set is a no-op rather than a full re-run.
    circleci tests glob "*.play.ts" \
        | circleci tests run --command="xargs -r $self" --verbose
else
    # Runner: the given spec files, or the whole suite if none were passed.
    reporter="line"
    [ -n "${PLAYWRIGHT_JUNIT_OUTPUT_NAME:-}" ] && reporter="line,junit"
    exec npx playwright test --reporter="$reporter" "$@"
fi
