#! /bin/bash

# build and push docker images used in CI

set -e
set -x

"$(dirname -- "${BASH_SOURCE[0]}")"/release_docker.sh skiplang skiplang-bin-builder skip skdb-base
