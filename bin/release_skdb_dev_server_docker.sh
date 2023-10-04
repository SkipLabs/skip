#! /bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$SCRIPT_DIR/../" || exit 1

docker buildx create --use

docker buildx build \
       --progress=plain \
       --platform linux/amd64,linux/arm64 \
       -t skiplabs/skdb-dev-server:latest \
       --push \
       .

# TODO: keep versions and alias latest
