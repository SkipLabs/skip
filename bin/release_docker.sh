#! /bin/bash

# if hitting space issues, try some of these
# docker system df
# docker system prune
# docker system prune -a
# docker volume rm $(docker volume ls -qf dangling=true)
# docker image rm $(docker image ls -qf dangling=true)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR/../" || exit 1

usage() {
    echo "Usage: $0 NAME:TAG+"
    echo "  where NAME:TAG is one of"
    echo "    skdb:latest"
    echo "    skdb-base:latest"
    echo "    skdb-dev-server:latest, skdb-dev-server:quickstart"
    echo "  the tag latest can be omitted"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

for name_tag in "$@"; do
  case "${name_tag%:latest}" in
    skdb)
      BUILD_SKDB=true
      ;;
    skdb-base)
      BUILD_SKDB_BASE=true
      ;;
    skdb-dev-server)
      BUILD_SKDB_DEV_SERVER_ARGS+=(--tag skiplabs/skdb-dev-server:latest)
      ;;
    skdb-dev-server:quickstart)
      BUILD_SKDB_DEV_SERVER_ARGS+=(--tag skiplabs/skdb-dev-server:quickstart)
      ;;
    *)
      echo "Unknown NAME:TAG '$name_tag'"
      echo
      usage
      exit 1
  esac
done

git clean -xd --dry-run | sed 's|Would remove |/|g' >> .dockerignore
echo ".git" >> .dockerignore

builder=$(docker buildx create --use)

dockerbuild () {
  docker buildx build \
       . \
       --no-cache \
       --progress=plain \
       --platform linux/amd64,linux/arm64 \
       --push \
       "$@"
}

if ${BUILD_SKDB_BASE:-false}; then
  dockerbuild --file Dockerfile --tag skiplabs/skdb-base:latest
fi

if ${BUILD_SKDB:-false}; then
  dockerbuild --file sql/Dockerfile --tag skiplabs/skdb:latest
fi

if [ ${#BUILD_SKDB_DEV_SERVER_ARGS[@]} -gt 0 ]; then
  dockerbuild --file sql/server/dev/Dockerfile "${BUILD_SKDB_DEV_SERVER_ARGS[@]}"
fi

docker buildx stop "$builder"
docker buildx rm "$builder"

git restore .dockerignore
