#!/usr/bin/env bash
set -euo pipefail
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
lean_checkout=${LEAN_ROOT:-"$project_dir/../../lean4"}
if [[ -f "$lean_checkout/build/release/env.sh" ]]; then
  source "$lean_checkout/build/release/env.sh"
else
  export PATH="$lean_checkout/build/release/stage1/bin:$PATH"
fi
cd "$project_dir"
mkdir -p build
export SKC=${SKC:-skc}
case "${1:-all}" in
  export)
    lean --run Export.lean build/elaborator.jsonl.tmp Lean.Elab
    mv build/elaborator.jsonl.tmp build/elaborator.jsonl
    python3 tools/build.py --stamp-export
    ;;
  emit)
    python3 tools/build.py > build/generated-sources.txt
    ;;
  check)
    python3 check.py build/generated --skc "$SKC" --jobs "${JOBS:-2}"
    ;;
  native)
    python3 check.py build/generated --skc "$SKC" --jobs "${JOBS:-2}" --native
    ;;
  test)
    (cd tests && lean -o Fixture.olean Fixture.lean) > build/fixture-lean.log
    LEAN_PATH="$project_dir/tests${LEAN_PATH:+:$LEAN_PATH}" lean --run Export.lean build/fixture.jsonl Fixture
    python3 transpile.py build/fixture.jsonl build/fixture --prefix Fixture.
    python3 tests/run.py
    ;;
  all)
    "$0" export
    "$0" emit
    "$0" test
    "$0" check
    "$0" native
    ;;
  *)
    echo 'usage: run.sh [export|emit|test|check|native|all]' >&2
    exit 2
    ;;
esac
