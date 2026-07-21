#!/bin/bash

# TODO: This is flaky as it relies on coarse directory-level diffs.

BASE="$(git merge-base main HEAD)"

git diff --quiet HEAD "$BASE" -- examples/
examples=$?

shopt -s globstar
declare -A SK_CHANGED
for skargo_toml in **/Skargo.toml; do
  dir=$(dirname "$skargo_toml")
  git diff --quiet HEAD "$BASE" -- "$dir" :^"$dir/ts" \
    && SK_CHANGED["$dir"]=false || SK_CHANGED["$dir"]=true
done

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

# Cycle-safe BFS over the reverse graph, seeded with the directly-changed packages.
queue=()
for pkg in "${!SK_CHANGED[@]}"; do ${SK_CHANGED["$pkg"]} && queue+=("$pkg"); done
while [ "${#queue[@]}" -gt 0 ]; do
  cur="${queue[0]}"; queue=("${queue[@]:1}")
  for dependent in ${SK_RDEPS["$cur"]:-}; do
    if [ "${SK_CHANGED[$dependent]:-false}" != true ]; then
      SK_CHANGED["$dependent"]=true
      queue+=("$dependent")
    fi
  done
done

check_ts=false
declare -A TS_CHANGED
# shellcheck disable=SC2046 # We actually want splitting in jq command output
for dir in $(jq --raw-output ".workspaces[]" package.json); do
  git diff --quiet HEAD "$BASE" -- "$dir" \
    && TS_CHANGED["$dir"]=false || TS_CHANGED["$dir"]=true
  ${TS_CHANGED["$dir"]} && check_ts=true
done

for dir in "${!SK_CHANGED[@]}"; do
  ${SK_CHANGED["$dir"]} && TS_CHANGED["$dir"]=true
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
if ! git diff --quiet HEAD "$BASE" -- \
     Makefile package.json package-lock.json bin/ skipruntime-ts/Makefile; then
  check_ts=true
  TS_CHANGED[skipruntime-ts]=true
  TS_CHANGED[sql]=true
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
        echo "      - skdb"
        NAMES+=(skdb)
        ;;
      skiplang/compiler)
        echo "      - compiler"
        NAMES+=(compiler)
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
        NAMES+=("$name")
    esac
  fi
done

if ${TS_CHANGED[sql]}
then
    echo "      - skdb-wasm"
    NAMES+=(skdb-wasm)
fi

if ${TS_CHANGED[skipruntime-ts]}
then
    echo "      - skipruntime"
    echo "      - skipruntime-bun"
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
