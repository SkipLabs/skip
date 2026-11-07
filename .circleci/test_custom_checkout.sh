#!/bin/bash

# Test the `custom-checkout` commands of .circleci/config.yml and base.yml
# against local repositories standing in for GitHub, in particular when the
# pipeline's branch has moved, been force-pushed or been deleted since the push
# that triggered it (#1614).
#
# Usage: .circleci/test_custom_checkout.sh

set -euo pipefail

CIRCLECI_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# Isolate git from the caller's configuration, and let submodules be cloned
# over file:// (disallowed by default since git 2.38.1).
export HOME="$WORK/home" GIT_CONFIG_NOSYSTEM=1
mkdir -p "$HOME"
git config --global user.name test
git config --global user.email test@example.com
git config --global init.defaultBranch main
git config --global advice.detachedHead false
git config --global protocol.file.allow always

# Print the `command: |` block of the custom-checkout command in $1, with each
# `<< parameters.NAME >>` replaced by the value given as NAME=VALUE in $2...
extract() {
  local file=$1
  shift
  local script
  script=$(awk '
    /^  custom-checkout:$/ { in_cmd = 1; next }
    in_cmd && /^          command: \|$/ { in_body = 1; next }
    in_body && /^            / { print substr($0, 13); next }
    in_body && /^$/ { print; next }
    in_body { exit }
  ' "$file")
  for param in "$@"; do
    script=${script//"<< parameters.${param%%=*} >>"/${param#*=}}
  done
  if [[ "$script" == *"<< parameters."* ]]; then
    echo "unsubstituted parameter in $file's custom-checkout" >&2
    exit 1
  fi
  printf '%s\n' "$script"
}

SCRIPTS=(
  "config.yml with_main=true"
  "config.yml with_main=false"
  "base.yml submodules=true"
  "base.yml submodules=false"
)
for spec in "${SCRIPTS[@]}"; do
  read -r -a args <<<"$spec"
  # shellcheck disable=SC2001 # Not a simple substitution
  name=$(echo "$spec" | sed 's/[ =]/-/g')
  extract "$CIRCLECI_DIR/${args[0]}" "${args[@]:1}" >"$WORK/$name.sh"
  if [ ! -s "$WORK/$name.sh" ]; then
    echo "custom-checkout not found in ${args[0]}" >&2
    exit 1
  fi
  if command -v shellcheck >/dev/null; then
    shellcheck --shell=bash "$WORK/$name.sh"
  fi
done

# Upstream: a submodule with two commits, the superproject pinning the first
# (not the submodule's tip), and a bare clone of the superproject as "GitHub".
git init -q "$WORK/sub"
git -C "$WORK/sub" commit -q --allow-empty -m "sub 1"
SUB_PINNED=$(git -C "$WORK/sub" rev-parse HEAD)
git -C "$WORK/sub" commit -q --allow-empty -m "sub 2"
# Like GitHub, serve the (non-tip) pinned commit by SHA, even to the protocol
# v0 clients of the fallback cases below.
git -C "$WORK/sub" config uploadpack.allowReachableSHA1InWant true

git init -q "$WORK/src"
git -C "$WORK/src" -c protocol.file.allow=always submodule -q add "file://$WORK/sub" sub
git -C "$WORK/src/sub" checkout -q "$SUB_PINNED"
git -C "$WORK/src" add sub
git -C "$WORK/src" commit -q -m "main 1"
git -C "$WORK/src" commit -q --allow-empty -m "main 2"
MAIN_TIP=$(git -C "$WORK/src" rev-parse HEAD)
git -C "$WORK/src" checkout -q -b feature HEAD~1
git -C "$WORK/src" commit -q --allow-empty -m "feature 1"
FEATURE_1=$(git -C "$WORK/src" rev-parse HEAD)
git -C "$WORK/src" commit -q --allow-empty -m "feature 2"
FEATURE_2=$(git -C "$WORK/src" rev-parse HEAD)
git -C "$WORK/src" checkout -q main
git clone -q --bare "$WORK/src" "$WORK/origin.git"
ORIGIN="$WORK/origin.git"
MERGE_BASE=$(git -C "$ORIGIN" merge-base main feature)

# Branch states, applied to a fresh copy of the bare repository per case.
tip() { :; }
moved() { git -C "$ORIGIN" update-ref refs/heads/feature "$FEATURE_2"; }
force_pushed() {
  local other
  other=$(git -C "$ORIGIN" commit-tree -p "$MERGE_BASE" -m "rewritten" "$MERGE_BASE^{tree}")
  git -C "$ORIGIN" update-ref refs/heads/feature "$other"
}
deleted_after_merge() {
  local merge
  merge=$(git -C "$ORIGIN" commit-tree -p "$MAIN_TIP" -p "$FEATURE_1" -m "merge" "$FEATURE_1^{tree}")
  git -C "$ORIGIN" update-ref refs/heads/main "$merge"
  git -C "$ORIGIN" update-ref -d refs/heads/feature
}
pull_request() { git -C "$ORIGIN" update-ref refs/pull/7/head "$FEATURE_1"; }
pull_request_moved() { git -C "$ORIGIN" update-ref refs/pull/7/head "$FEATURE_2"; }

failures=0

# run SCRIPT STATE BRANCH SHA EXPECT [GIT_CONFIG...]: run the checkout SCRIPT
# in an empty directory, against an origin in STATE, as a pipeline for
# BRANCH at SHA. EXPECT is "ok" or "gone". GIT_CONFIG entries (key=value)
# apply to every git command the script runs.
run() {
  local script=$1 state=$2 branch=$3 sha=$4 expect=$5
  shift 5
  local label="$script / $state / $branch${*:+ / $*}"
  rm -rf "$WORK/origin.git" "$WORK/project" "$HOME/.ssh"
  git clone -q --bare "$WORK/src" "$WORK/origin.git"
  "$state"
  local expected_base
  expected_base=$(git -C "$ORIGIN" merge-base main "$sha" 2>/dev/null || true)
  mkdir "$WORK/project"
  local env=(CIRCLE_BRANCH="$branch" CIRCLE_SHA1="$sha" CIRCLE_TAG=
    CIRCLE_REPOSITORY_URL="file://$ORIGIN" CHECKOUT_KEY=
    GIT_CONFIG_COUNT=$#)
  local i=0
  for kv in "$@"; do
    env+=("GIT_CONFIG_KEY_$i=${kv%%=*}" "GIT_CONFIG_VALUE_$i=${kv#*=}")
    i=$((i + 1))
  done
  local status=0
  (cd "$WORK/project" && env "${env[@]}" bash -eo pipefail "$WORK/$script.sh" </dev/null) \
    >"$WORK/log" 2>&1 || status=$?
  local problem=""
  if [ "$expect" = gone ]; then
    if [ "$status" -eq 0 ]; then
      problem="succeeded although $sha does not exist"
    elif ! grep -q "ERROR: could not fetch commit $sha of $branch" "$WORK/log"; then
      problem="failed without the expected message"
    fi
  elif [ "$status" -ne 0 ]; then
    problem="failed with status $status"
  else
    local head branch_head
    head=$(git -C "$WORK/project" rev-parse HEAD)
    branch_head=$(git -C "$WORK/project" symbolic-ref --short HEAD)
    if [ "$head" != "$sha" ]; then
      problem="checked out $head"
    elif [ "$branch_head" != "$branch" ]; then
      problem="on branch $branch_head"
    elif [[ "$script" == *with_main-true ]] \
      && [ "$(git -C "$WORK/project" merge-base main HEAD)" != "$expected_base" ]; then
      problem="local main is missing or wrong"
    elif [[ "$script" == *submodules-true ]] \
      && [ "$(git -C "$WORK/project/sub" rev-parse HEAD 2>/dev/null)" != "$SUB_PINNED" ]; then
      problem="submodule not checked out at the pinned commit"
    fi
  fi
  if [ -n "$problem" ]; then
    echo "FAIL: $label: $problem"
    sed 's/^/    /' "$WORK/log"
    failures=$((failures + 1))
  else
    echo "ok: $label"
  fi
}

GONE=0123456789abcdef0123456789abcdef01234567
for spec in "${SCRIPTS[@]}"; do
  # shellcheck disable=SC2001 # Not a simple substitution
  script=$(echo "$spec" | sed 's/[ =]/-/g')
  run "$script" tip feature "$FEATURE_1" ok
  run "$script" tip main "$MAIN_TIP" ok
  run "$script" moved feature "$FEATURE_1" ok
  run "$script" force_pushed feature "$FEATURE_1" ok
  run "$script" deleted_after_merge feature "$FEATURE_1" ok
  run "$script" pull_request pull/7 "$FEATURE_1" ok
  run "$script" tip feature "$GONE" gone
  run "$script" deleted_after_merge feature "$GONE" gone
  # A server that refuses fetches by SHA (protocol v0 without
  # uploadpack.allow*SHA1InWant) exercises the fallback to the branch or PR
  # ref, including when the commit is no longer its tip.
  run "$script" tip feature "$FEATURE_1" ok protocol.version=0
  run "$script" moved feature "$FEATURE_1" ok protocol.version=0
  run "$script" pull_request_moved pull/7 "$FEATURE_1" ok protocol.version=0
  run "$script" force_pushed feature "$FEATURE_1" gone protocol.version=0
done

if [ "$failures" -ne 0 ]; then
  echo "$failures failure(s)"
  exit 1
fi
echo "All custom-checkout tests passed"
