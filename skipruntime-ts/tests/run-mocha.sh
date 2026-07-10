#!/bin/bash
# Run the skipruntime mocha unit-test suite.
#
# In CircleCI (CIRCLECI is set) the suite is wrapped in `circleci tests run` so
# the "Rerun failed tests" button reruns only the spec files that failed, and a
# JUnit report is emitted (via junit-spec-reporter.cjs) for CircleCI to track
# failures. `circleci tests run` re-invokes this script with the (failed, on a
# rerun) spec files as arguments, taking the runner branch below. Everywhere
# else -- local `npm test` / `make test` -- we run the whole suite with mocha's
# default spec reporter.
#
# NB: .mocharc.json must NOT set `spec`. mocha 11 *merges* positional spec files
# with a configured `spec`, so a configured glob would make every rerun re-run
# the whole suite. The spec glob lives here instead.
set -euo pipefail

cd "$(dirname "$0")" || exit 1
self="$PWD/$(basename "$0")"
specs="dist/**/*.spec.js"

if [ -n "${CIRCLECI:-}" ] && [ -z "${SKIPRUNTIME_TESTS_INNER:-}" ]; then
    # Orchestrator: let `circleci tests run` pick the specs (all of them
    # normally, only the previously-failed ones on a rerun).
    mkdir -p "$HOME/test-results"
    export SKIPRUNTIME_TESTS_INNER=1
    # A single fixed report path is fine: the spec set is one xargs batch, so
    # one mocha run writes it. store_test_results ingests the whole directory.
    export MOCHA_FILE="$HOME/test-results/skipruntime.xml"
    files=$(circleci tests glob "$specs")
    # Fail loudly rather than pass green with zero tests if nothing matched
    # (e.g. dist not built); `circleci tests run` would otherwise no-op.
    [ -n "$files" ] || { echo "run-mocha.sh: no spec files matched '$specs' (is dist built?)" >&2; exit 1; }
    # -r: an empty rerun set is a no-op rather than a full re-run. Single-quote
    # $self so it survives the shell re-parse inside `circleci tests run`.
    printf '%s\n' "$files" \
        | circleci tests run --command="xargs -r '$self'" --verbose
else
    # Runner: the given spec files, or the whole suite if none were passed.
    # junit-spec-reporter.cjs also prints mocha's normal spec output, so use it
    # whenever a JUnit report is wanted (CI); plain spec reporter otherwise.
    reporter="spec"
    [ -n "${MOCHA_FILE:-}" ] && reporter="./junit-spec-reporter.cjs"
    if [ "$#" -eq 0 ]; then
        exec npx mocha --reporter "$reporter" "$specs"
    else
        exec npx mocha --reporter "$reporter" "$@"
    fi
fi
