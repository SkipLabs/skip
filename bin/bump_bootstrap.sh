#!/bin/bash

# Rebuild the skiplang bootstrap compiler from the current source and verify it,
# the mechanical core of a bootstrap bump. The caller (a maintainer, or
# .github/workflows/bump-bootstrap.yml) commits and pushes the result.
#
# Steps, matching the manual process:
#   1. Build stage1 with the current (old) bootstrap and promote its IR into the
#      bootstrap submodule -- bootstrap/{skc,skargo,skfmt}_out64.ll.gz.
#   2. Verify the NEW bootstrap in isolation: a clean rebuild from those files,
#      through stage3, must satisfy the self-hosting fixpoint (the compiler
#      recompiles itself to an identical result), and the full test suite must
#      pass.
#
# On success the bootstrap/*.ll.gz files are left modified (promoted) and
# verified, and the submodule's HEAD is untouched -- the caller commits and
# pushes. On ANY failure this exits non-zero having pushed nothing, so a broken
# compiler never reaches the bootstrap repository.
#
# Must run from a full checkout with the bootstrap and libbacktrace submodules
# initialised, and a skiplang build toolchain on PATH (clang, llvm, lld, make).
#
# Usage: bin/bump_bootstrap.sh

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR/../skiplang/compiler"

commit=$(git rev-parse --short HEAD)
echo "==> Rebuilding bootstrap for source commit $commit"

# 1. Build stage1 with the current bootstrap and promote its IR. `make promote`
#    builds stage1 (from the old bootstrap's stage0) first. Start clean so the
#    skc-*.ll glob promote copies from is unambiguous.
make clean
make promote

# 2. Verify the promoted bootstrap on its own. `make clean` removes stage*/build
#    but leaves the freshly promoted bootstrap/*.ll.gz, so this rebuild starts
#    from the NEW IR. A full clean is required: the stage rules key off stage
#    directory mtimes, so a partial clean would reuse stale stages.
make clean
make stage3

# 2a. Fixpoint: the new compiler must compile itself to the same IR twice over.
#     The Makefile's own check is `-diff` (leading dash -> exit code ignored), so
#     it never fails the build; assert it here.
if ! diff -q stage2/bin/skc.ll stage3/bin/skc.ll; then
    echo "" >&2
    echo "ERROR: bootstrap fixpoint failed -- stage2 and stage3 skc.ll differ." >&2
    echo "The promoted compiler does not converge on itself; refusing to publish." >&2
    exit 1
fi
echo "==> Fixpoint OK: stage2 and stage3 skc.ll are identical"

# 2b. Sanity: stage0, now built from the promoted IR, should report this commit.
#     Informational -- the fixpoint and tests are the real gates -- so a version
#     string that does not mention the commit warns rather than fails.
version=$(stage0/bin/skc --version 2>/dev/null || true)
echo "==> New stage0 reports: ${version:-<no --version output>}"
case "$version" in
    *"$commit"*) ;;
    *) echo "WARNING: stage0 --version does not mention $commit; double-check the promoted IR" >&2 ;;
esac

# 3. Full compiler test suite against the newly bootstrapped compiler.
make test

echo ""
echo "==> Bootstrap rebuilt and verified for $commit."
echo "    Promoted, ready to commit: bootstrap/{skc,skargo,skfmt}_out64.ll.gz"
