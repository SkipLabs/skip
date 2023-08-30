#! /bin/bash

set -x
set -e

cd ~/code/skfs || exit 1

find . -name state.db|xargs rm

echo "Building ref server image"
# TODO: needs to buildx for x86 and arm
docker build -t skdb-ref-server --progress=plain -f sql/server/reference/Dockerfile .

echo "Pushing image to docker"
echo "TODO: NOT YET IMPLEMENTED"
