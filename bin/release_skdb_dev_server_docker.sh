#! /bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$SCRIPT_DIR/../" || exit 1

make test

# TODO: multiple platforms
docker build -t skdb-dev-server --progress=plain -f sql/server/dev/Dockerfile .

# TODO: old versions?

docker tag skdb-dev-server:latest skiplabs/skdb-dev-server:latest

docker push skiplabs/skdb-dev-server:latest
