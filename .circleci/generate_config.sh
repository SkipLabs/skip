#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.

BASE="$(git merge-base main HEAD)"

# Changes that cannot affect a build or test result must not trigger tests or
# compilation, so every diff below excludes them: documentation (markdown
# anywhere in the tree) and .gitignore files (builds and Docker contexts do not
# read them; the latter use .dockerignore).
NON_BUILD_EXCLUDES=(
  ':(exclude)*.md'
  ':(glob,exclude)**/*.md'
  ':(glob,exclude)**/*.mdx'
  ':(glob,exclude)**/.gitignore'
)

# Files that no CircleCI job reads, although they sit under a path that
# triggers jobs (bin/ or the sql package). List a path here only when nothing
# a job runs (its steps, Makefiles, scripts, npm/skargo/gradle builds) reads it;
# anything not listed keeps triggering.
NO_CI_JOB_EXCLUDES=(
  # Docker image build, publish and bootstrap-bump scripts, run by GitHub
  # Actions or by hand. CircleCI jobs use the already-published images and
  # never build these (HACKING.md, "Publishing CI Docker images").
  ':(exclude)bin/apt-install.sh'
  ':(exclude)bin/build_docker_images.sh'
  ':(exclude)bin/build_prod_skdb_images.sh'
  ':(exclude)bin/bump_bootstrap.sh'
  ':(exclude)bin/check_bootstrap_token.sh'
  ':(exclude)bin/check_ci_images.sh'
  ':(exclude)bin/check_push_access.sh'
  ':(glob,exclude)bin/release_docker*.sh'
  ':(exclude)sql/Dockerfile'
  ':(exclude)sql/server/core/Dockerfile'
  ':(exclude)sql/server/dev/Dockerfile'
  # npm publishing, run only by the root Makefile's publish-* targets.
  ':(exclude)bin/release_npm.sh'
  # Local developer tooling. The formatting gate (fast-checks) always runs and
  # does not use these hooks.
  ':(exclude)bin/claude_hooks/'
  ':(exclude)bin/git_hooks/'
  ':(exclude)bin/migrate-old-history-branches.sh'
  # skdb consumer smoke tests for `make check-vite` and `make test-bun`, which no
  # job runs. sql/ts's tsconfig.json and eslint.config.js exclude them, and they
  # are not npm workspaces.
  ':(exclude)sql/ts/bun/'
  ':(exclude)sql/ts/vitejs/'
)

# Exit 0 when the diff restricted to the given paths has no build-relevant change.
changed() {
  git diff --quiet HEAD "$BASE" -- "$@" "${NON_BUILD_EXCLUDES[@]}" \
    "${NO_CI_JOB_EXCLUDES[@]}"
}

changed examples/
examples=$?

shopt -s globstar

# Test-only paths are read by a single package's job and are not part of what
# its dependents compile against, so a change confined to them schedules that
# job alone: no reverse dependencies, no TS jobs. Each package's own tests/ is
# one: skargo compiles tests/*.sk only into the test target of the package it
# builds (manifest_targets in skiplang/skargo/src/manifest.sk), never into the
# library a dependent links, and no package, Makefile or script reads another
# package's tests/. A `tests = [...]` key in any Skargo.toml could point a test
# target elsewhere, so that disables the rule. TEST_ONLY_PATHS adds other such
# paths, mapped to the package whose job reads them.
declare -A TEST_ONLY_PATHS=(
  # C regression tests run by the compiler job's "Run runtime regressions"
  # step only; prelude's build.sk and runtime/Makefile do not compile them.
  [skiplang/prelude/runtime/tests]=skiplang/compiler
)
narrow_tests=true
grep -qE '^tests *=' -- **/Skargo.toml && narrow_tests=false

# SK_LIB_CHANGED: the package's library or binaries changed, which its
# dependents and the TS jobs see. SK_CHANGED: the package's own job must run.
declare -A SK_CHANGED SK_LIB_CHANGED
for skargo_toml in **/Skargo.toml; do
  dir=$(dirname "$skargo_toml")
  test_only=()
  if $narrow_tests; then
    test_only=(":^$dir/tests")
    for path in "${!TEST_ONLY_PATHS[@]}"; do test_only+=(":^$path"); done
  fi
  changed "$dir" :^"$dir/ts" "${test_only[@]}" \
    && SK_LIB_CHANGED["$dir"]=false || SK_LIB_CHANGED["$dir"]=true
  SK_CHANGED["$dir"]=${SK_LIB_CHANGED["$dir"]}
  $narrow_tests && ! changed "$dir/tests" && SK_CHANGED["$dir"]=true
done
if $narrow_tests; then
  for path in "${!TEST_ONLY_PATHS[@]}"; do
    changed "$path" || SK_CHANGED["${TEST_ONLY_PATHS[$path]}"]=true
  done
fi

# The Docker images ship a stage0 toolchain built from the pinned bootstrap and
# the prelude runtime. When this diff changes those inputs, jobs that compile
# with the image's toolchain would still test the previously published one, so
# a broken bootstrap or runtime only shows up after the next publish (#1602).
# Instead, run every job that compiles Skip code, have each wait for `compiler`,
# and install the stage0 it built (base.yml: use-candidate-toolchain). Marking
# the prelude changed reaches all of them: every package depends on it, and it
# routes to the skdb and skipruntime job sets below. check-ts and
# check-examples don't use the Skip toolchain and are unaffected.
candidate=false
if ! changed skiplang/compiler/bootstrap skiplang/compiler/Makefile \
     skiplang/prelude/runtime ':^skiplang/prelude/runtime/tests' \
     skiplang/prelude/Makefile skiplang/prelude/libbacktrace; then
  candidate=true
  SK_CHANGED[skiplang/compiler]=true
  SK_LIB_CHANGED[skiplang/compiler]=true
  SK_CHANGED[skiplang/prelude]=true
  SK_LIB_CHANGED[skiplang/prelude]=true
fi

# Emit the parameters that make an image-toolchain job use the candidate
# toolchain, when there is one.
candidate_params() {
  if $candidate; then
    echo "          candidate_toolchain: true"
    echo "          requires:"
    echo "            - compiler"
  fi
}

# Retest every package that (transitively) depends on a changed one, so a change
# to a shared library reaches its dependents' jobs. The reverse dependency graph
# is derived from the `path = "..."` entries in each Skargo.toml (all dependency
# sections), rather than hand-maintained, so it stays correct as packages change.
declare -A SK_DEPS
for skargo_toml in **/Skargo.toml; do
  dir=$(dirname "$skargo_toml")
  deps=""
  while IFS= read -r dep_path; do
    [ -n "$dep_path" ] || continue
    resolved=$(realpath -m --relative-to=. "$dir/$dep_path" 2>/dev/null)
    [ -f "$resolved/Skargo.toml" ] && deps="$deps $resolved"
  done < <(awk '/^\[(dev-|build-)?dependencies\]/{d=1;next} /^\[/{d=0} d && /path *=/{print}' "$skargo_toml" \
           | grep -oE 'path *= *"[^"]+"' | sed 's/.*"\(.*\)"/\1/')
  SK_DEPS["$dir"]="$deps"
done

declare -A SK_RDEPS
for pkg in "${!SK_DEPS[@]}"; do
  for dep in ${SK_DEPS[$pkg]}; do
    SK_RDEPS["$dep"]="${SK_RDEPS[$dep]:-} $pkg"
  done
done

# Cycle-safe BFS over the reverse graph, seeded with the packages whose library
# changed (a test-only change does not reach dependents).
queue=()
for pkg in "${!SK_LIB_CHANGED[@]}"; do ${SK_LIB_CHANGED["$pkg"]} && queue+=("$pkg"); done
while [ "${#queue[@]}" -gt 0 ]; do
  cur="${queue[0]}"; queue=("${queue[@]:1}")
  for dependent in ${SK_RDEPS["$cur"]:-}; do
    if [ "${SK_LIB_CHANGED[$dependent]:-false}" != true ]; then
      SK_LIB_CHANGED["$dependent"]=true
      SK_CHANGED["$dependent"]=true
      queue+=("$dependent")
    fi
  done
done

# Skargo's incremental integration tests exercise the compiler from this checkout.
# Schedule its producer even when only the driver changed.
if ${SK_CHANGED[skiplang/skargo]:-false}; then
  SK_CHANGED[skiplang/compiler]=true
fi

check_ts=false
declare -A TS_CHANGED
# shellcheck disable=SC2046 # We actually want splitting in jq command output
for dir in $(jq --raw-output ".workspaces[]" package.json); do
  # A workspace's own lockfiles (e.g. Dependabot bumps of
  # examples/blogger/reactive_service/package-lock.json) do not affect the TS
  # jobs: they install with npm from the root, which resolves every workspace
  # from the root package-lock.json and ignores lockfiles inside workspaces.
  # check-examples still sees them through the examples/ diff.
  changed "$dir" ":^$dir/package-lock.json" ":^$dir/pnpm-lock.yaml" \
          ":^$dir/pnpm-workspace.yaml" \
    && TS_CHANGED["$dir"]=false || TS_CHANGED["$dir"]=true
  ${TS_CHANGED["$dir"]} && check_ts=true
done

# The TS packages build against the Skip libraries, not their tests.
for dir in "${!SK_LIB_CHANGED[@]}"; do
  ${SK_LIB_CHANGED["$dir"]} && TS_CHANGED["$dir"]=true
done

for dir in "${!TS_CHANGED[@]}"; do
  changed=${TS_CHANGED["$dir"]}
  while [ "$dir" != "." ] && [ "$dir" != "/" ]; do
    if ${TS_CHANGED["$dir"]:-false} && ! $changed; then break; fi
    TS_CHANGED["$dir"]=$changed
    dir=$(dirname "$dir")
  done
done

if ${TS_CHANGED[skiplang/skjson]}; then
  TS_CHANGED[sql]=true
  TS_CHANGED[skipruntime-ts]=true
fi
if ${TS_CHANGED[skiplang/prelude]}; then
  TS_CHANGED[sql]=true
  TS_CHANGED[skipruntime-ts]=true
fi

# Shared build and dependency infrastructure that no single workspace or Skargo
# package owns, so the allowlists above attribute it to no job. These paths feed
# the npm install + libskipruntime build shared by the TS jobs (check-ts,
# skipruntime, skipruntime-bun, skdb-wasm): the root lockfile pins compile inputs
# such as node-addon-api (linked by skipruntime-ts/addon/binding.gyp), and the
# Makefiles/bin scripts drive those builds. Without this a change to e.g. the
# lockfile or skipruntime-ts/Makefile runs no CI at all, even though it can break
# those builds -- so route it to the TS job set.
# prebuild.mjs links the Skip runtime TS sources into the workspaces whose
# typecheck/build scripts run it.
if ! changed \
     Makefile package.json package-lock.json bin/ skipruntime-ts/Makefile \
     prebuild.mjs; then
  check_ts=true
  TS_CHANGED[skipruntime-ts]=true
  TS_CHANGED[sql]=true
fi

# The skipruntime job's native addon test builds libskipruntime in Docker
# (skipruntime-ts/tests/native_addon_unreleased/run.sh -> bin/build_runtime.sh
# -> the `skipruntime` bake target), which builds skiplang/Dockerfile and
# skipruntime-ts/Dockerfile with the build contexts filtered by .dockerignore.
if ! changed \
     skiplang/Dockerfile skipruntime-ts/Dockerfile docker-bake.hcl .dockerignore
then
  TS_CHANGED[skipruntime-ts]=true
fi

# A PR that edits a job's definition in base.yml must run that job, or the edit
# goes untested until an unrelated PR triggers it (#1601). Split base.yml into
# sections (each job under `jobs:`, every other top-level key) and print the
# names of those that differ between BASE and HEAD, ignoring comment-only and
# blank lines (a comment above a job would otherwise count towards the previous
# one). config.yml and this script need no rule: every pipeline runs them in its
# setup and fast-checks jobs.
changed_base_yml_sections() {
  awk '
    FNR == 1 { f = (FILENAME == ARGV[1]) ? 1 : 2; top = ""; key = "" }
    /^[ \t]*(#.*)?$/ { next }
    /^[^ ]/ { top = $1; sub(/:.*/, "", top); key = top }
    top == "jobs" && /^  [^ #]/ { key = $1; sub(/:.*/, "", key) }
    { text[f, key] = text[f, key] $0 "\n"; keys[key] }
    END { for (k in keys) if (text[1, k] != text[2, k]) print k }
  ' <(git show "$BASE:.circleci/base.yml" 2>/dev/null) \
    <(git show "HEAD:.circleci/base.yml" 2>/dev/null)
}
if ! changed .circleci/base.yml; then
  while IFS= read -r section; do
    case "$section" in
      # skargo and backend-regressions run on the compiler job's workspace.
      compiler)
        SK_CHANGED[skiplang/compiler]=true
        SK_CHANGED[skiplang/skargo]=true ;;
      backend-regressions) SK_CHANGED[skiplang/compiler]=true ;;
      skdb) SK_CHANGED[sql]=true ;;
      skdb-wasm) TS_CHANGED[sql]=true ;;
      check-ts) check_ts=true ;;
      skipruntime | skipruntime-bun) TS_CHANGED[skipruntime-ts]=true ;;
      check-examples) examples=1 ;;
      all-checks) ;;
      # Every Skargo package except these three gets a skip-package-* job below.
      # skargo's job needs compiler, which is therefore scheduled too.
      skip-package-build | skip-package-tests)
        for dir in "${!SK_CHANGED[@]}"; do
          case "$dir" in
            sql | skipruntime-ts/*) ;;
            *) SK_CHANGED["$dir"]=true ;;
          esac
        done ;;
      # `commands:` (custom-checkout), `version:`, or a job this list does not
      # know: schedule everything.
      *)
        for dir in "${!SK_CHANGED[@]}"; do SK_CHANGED["$dir"]=true; done
        check_ts=true
        TS_CHANGED[sql]=true
        TS_CHANGED[skipruntime-ts]=true
        examples=1
        ;;
    esac
  done < <(changed_base_yml_sections)
fi

cat .circleci/base.yml

JOBS=$(mktemp)
trap 'rm -f "$JOBS"' EXIT

# Names of every job scheduled below, so the `all-checks` gate can require them.
NAMES=()

# The brace group runs in the current shell (redirection does not fork it), so
# NAMES accumulates across the blocks below.
{
if $check_ts
then
    echo "      - check-ts"
    NAMES+=(check-ts)
fi

for dir in "${!SK_CHANGED[@]}"; do
  if ${SK_CHANGED["$dir"]}; then
    case "$dir" in
      skipruntime-ts/* )
        TS_CHANGED[skipruntime-ts]=true
        ;;
      sql)
        if $candidate; then
          echo "      - skdb:"
          candidate_params
        else
          echo "      - skdb"
        fi
        NAMES+=(skdb)
        ;;
      skiplang/compiler)
        echo "      - compiler"
        # Runs on the compiler job's stage1 build, beside the other jobs that
        # wait for it, instead of extending the compiler job itself.
        echo "      - backend-regressions:"
        echo "          requires:"
        echo "            - compiler"
        NAMES+=(compiler backend-regressions)
        ;;
      skiplang/skargo)
        echo "      - skip-package-tests:"
        echo "          dir: $dir"
        echo "          name: skargo"
        echo "          candidate_compiler: true"
        echo "          requires:"
        echo "            - compiler"
        NAMES+=(skargo)
        ;;
      *)
        name=$(basename "$dir")
        if [ -d "$dir/tests" ]; then
          echo "      - skip-package-tests:"
        else
          echo "      - skip-package-build:"
        fi
        echo "          dir: $dir"
        echo "          name: $name"
        candidate_params
        NAMES+=("$name")
    esac
  fi
done

if ${TS_CHANGED[sql]}
then
    if $candidate; then
        echo "      - skdb-wasm:"
        candidate_params
    else
        echo "      - skdb-wasm"
    fi
    NAMES+=(skdb-wasm)
fi

if ${TS_CHANGED[skipruntime-ts]}
then
    for job in skipruntime skipruntime-bun; do
        if $candidate; then
            echo "      - $job:"
            candidate_params
        else
            echo "      - $job"
        fi
    done
    NAMES+=(skipruntime skipruntime-bun)
fi

if (( examples != 0 ))
then
    echo "      - check-examples"
    NAMES+=(check-examples)
fi
} > "$JOBS"

# Schedule every triggered job in a single `ci` workflow, gated by `all-checks`.
# The gate depends on all of them, so its status context (`ci/circleci:
# ci/all-checks` -- see the note on the job in base.yml) only turns green once
# every triggered job has passed. It is always emitted -- even when no jobs are
# triggered -- so it is a stable required check that branch protection /
# auto-merge can wait on regardless of the diff.
echo "workflows:"
echo "  ci:"
echo "    jobs:"
cat "$JOBS"
if [ "${#NAMES[@]}" -gt 0 ]; then
  echo "      - all-checks:"
  echo "          requires:"
  for name in "${NAMES[@]}"; do
    echo "            - $name"
  done
else
  echo "      - all-checks"
fi
