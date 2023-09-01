#! /bin/bash

set -x
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO="$SCRIPT_DIR/../../.."
cd $REPO || exit 1

git clean -xdn | sed 's|Would remove |/|g' > .dockerignore

echo "Building ref server image"
# TODO: needs to buildx for x86 and arm
docker build -t skdb-ref-server --progress=plain -f sql/server/reference/Dockerfile .

git restore .dockerignore
echo "Pushing image to docker"
echo "TODO: NOT YET IMPLEMENTED"
