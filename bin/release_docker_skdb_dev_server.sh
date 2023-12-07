#! /bin/bash

# if hitting space issues, try some of these
# docker system df
# docker system prune
# docker system prune -a
# docker volume rm $(docker volume ls -qf dangling=true)
# docker image rm $(docker image ls -qf dangling=true)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$SCRIPT_DIR/../" || exit 1

read -r -p "Release 'latest' version? [y/N] " latest
if [[ "$latest" =~ ^([yY]|[yY][eE][sS])$ ]]; then
    push_latest="-t skiplabs/skdb-dev-server:latest"
fi

read -r -p "Release 'quickstart' version? [y/N] " quickstart
if [[ "$quickstart" =~ ^([yY]|[yY][eE][sS])$ ]]; then
    push_quickstart="-t skiplabs/skdb-dev-server:quickstart"
fi

if [[ -z "$push_latest" && -z "$push_quickstart" ]]; then
    echo Nothing to do, exiting.
    exit 0
fi

git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

builder=$(docker buildx create --use)

docker buildx build \
       --no-cache \
       --progress=plain \
       --platform linux/amd64,linux/arm64 \
       $push_latest \
       $push_quickstart \
       -f sql/server/dev/Dockerfile \
       --push \
       .

# TODO: keep versions and alias latest

docker buildx stop "$builder"
docker buildx rm "$builder"

git restore .dockerignore
