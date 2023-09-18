#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPO="$SCRIPT_DIR/.."

set -e
set -x

cd $REPO

git clean -xdn | sed 's|Would remove |/|g' > .dockerignore
echo ".git" >> .dockerignore

docker build --no-cache --tag skfs --progress=plain .
docker build --no-cache --tag skgw --progress=plain --file sql/server/skgw/Dockerfile .
docker build --tag $USER-skfs --progress=plain --file $USER/Dockerfile .

git restore .dockerignore

echo disk usage:
docker system df

echo images:
docker images
