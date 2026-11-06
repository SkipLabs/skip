#!/bin/bash
# Build a toolchain from this checkout, then run selected downstream repros
# with it. Used by the CircleCI `repro` job, which only runs when
# skiplang/compiler/tools/ci_repro.env exists on the branch; that file sets
# the variables below, so each experiment is a one-line commit.
#
#   REPRO_TOOLCHAIN  image  : the image's /usr/bin toolchain (no build)
#                    stage0 : `make stage0` from the pinned bootstrap
#                    stage1 : `make STAGE=1` (stage0 builds this compiler)
#   REPRO_TESTS      space-separated: skdb-privacy skjs
#   REPRO_SKJS_REF   skjs branch or commit (default main)
#   REPRO_SKJS_TEST  skjs test filter
#                    (default testProbeSubtypeProposalLeavesTheOwnerAlone)
#   REPRO_SKCOPTS    extra skc options for the repro builds, space-separated
#   REPRO_EXPECT     pass (default) or fail: the job fails unless every repro
#                    has this outcome, so a known-bad toolchain can be checked
#                    to reproduce
set -uo pipefail

root=$(git rev-parse --show-toplevel)
toolchain=${REPRO_TOOLCHAIN:-stage1}
tests=${REPRO_TESTS:-skdb-privacy skjs}
expect=${REPRO_EXPECT:-pass}
out=${REPRO_OUT:-$root/skiplang/compiler/runs/repro}
mkdir -p "$out"

skargo_opts=()
for opt in ${REPRO_SKCOPTS:-}; do skargo_opts+=(--skcopt "$opt"); done

case "$toolchain" in
  image) bin=/usr/bin ;;
  stage0 | stage1)
    (cd "$root/skiplang/compiler" && make "$toolchain") || exit 2
    bin=$root/skiplang/compiler/$toolchain/bin
    ;;
  *)
    echo "Unknown REPRO_TOOLCHAIN: $toolchain" >&2
    exit 2
    ;;
esac
export PATH="$bin:$PATH"
echo "Toolchain $toolchain: $(skc --version | tail -n 1) ($(command -v skc))"

failed=()
passed=()

# Native skdb privacy tests (the permission tests from `make test-native`).
run_skdb_privacy() {
  (cd "$root/sql" && skargo build --release --bin skdb "${skargo_opts[@]}") ||
    return 2
  local work=$out/skdb-privacy
  rm -rf "$work"
  mkdir -p "$work"
  sed -e "s#/tmp/test.db#$work/test.db#" \
    -e "s#/tmp/test_copy.db#$work/test_copy.db#" \
    "$root/sql/test_privacy.sh" > "$work/test_privacy.sh"
  (cd "$root/sql" &&
    SKDB_BIN=$root/sql/target/host/release/skdb \
      timeout 300 bash "$work/test_privacy.sh") 2>&1 | tee "$work/out.txt"
  ! grep -q FAILED "$work/out.txt" &&
    [ "$(grep -c ' OK$' "$work/out.txt")" -ge 20 ]
}

# One skjs test, built against this checkout as ../skip.
run_skjs() {
  local parent=$out/skjs-parent
  rm -rf "$parent"
  mkdir -p "$parent"
  ln -s "$root" "$parent/skip"
  git clone --quiet https://github.com/SkipLabs/skjs "$parent/skjs" || return 2
  (cd "$parent/skjs" &&
    git checkout --quiet "${REPRO_SKJS_REF:-main}" &&
    echo "skjs $(git rev-parse --short HEAD)" &&
    skargo test "${skargo_opts[@]}" \
      "${REPRO_SKJS_TEST:-testProbeSubtypeProposalLeavesTheOwnerAlone}")
}

for test in $tests; do
  echo "=== $test"
  "run_${test//-/_}"
  status=$?
  echo "=== $test: exit $status"
  if [ "$status" -eq 0 ]; then passed+=("$test"); else failed+=("$test"); fi
done

echo "Passed: ${passed[*]:-none}. Failed: ${failed[*]:-none}. Expected: $expect."
if [ "$expect" = fail ]; then [ "${#passed[@]}" -eq 0 ]; else [ "${#failed[@]}" -eq 0 ]; fi
