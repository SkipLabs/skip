#!/usr/bin/env bash
set -euo pipefail
project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
cd "$project_dir"
mkdir -p build
export SKC=${SKC:-"$project_dir/../skiplang/compiler/stage1/bin/skc"}
case "${1:-build}" in
  build) skargo build ;;
  smoke) skargo run --bin lean4-smoke ;;
  check)
    python3 tools/whole_check.py
    ;;
  export|emit|all)
    echo 'Automatic transpilation has been retired. Edit the maintained Skip sources directly.' >&2
    exit 2
    ;;
  *)
    echo 'usage: run.sh [build|smoke|check]' >&2
    exit 2
    ;;
esac
