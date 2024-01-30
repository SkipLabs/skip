#! /bin/bash

# if hitting space issues, try some of these
# docker system df
# docker system prune
# docker system prune -a
# docker volume rm $(docker volume ls -qf dangling=true)
# docker image rm $(docker image ls -qf dangling=true)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd "$SCRIPT_DIR/../" || exit 1

git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

builder=$(docker buildx create --use)

docker buildx build \
       --no-cache \
       --progress=plain \
       --platform linux/amd64,linux/arm64 \
       -t skiplabs/skdb:latest \
       -f sql/Dockerfile \
       --push \
       .

docker buildx stop "$builder"
docker buildx rm "$builder"

git restore .dockerignore
