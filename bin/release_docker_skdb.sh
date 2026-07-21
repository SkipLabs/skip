#! /bin/bash

set -e
set -x

"$(dirname -- "${BASH_SOURCE[0]}")"/release_docker.sh skdb
