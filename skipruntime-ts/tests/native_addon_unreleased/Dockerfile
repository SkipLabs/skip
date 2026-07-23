# Node comes baked into the base image. Bookworm matches the glibc floor (2.36)
# of the debian:bookworm image that builds libskipruntime.so (see
# skiplang/Dockerfile), so the copied-in .so loads. Deliberately NOT
# `ubuntu:latest` + a nodesource apt repo: that downloaded Node over the network
# on every CI run -- setup_remote_docker gives an ephemeral daemon, so the apt
# cache never persists -- ballooning this step from ~30s to ~500s whenever those
# mirrors were slow.
FROM node:22.13.1-bookworm-slim

ARG TARGETARCH

# Install only the node-gyp toolchain (g++, make, python3), CA certificates, and
# curl -- build/install_runtime.sh uses it to copy the .so from the file:// source
# below. curl, not wget: GNU wget does not support file:// URLs. (This slipped by
# under the old ubuntu base only because that image happened to ship curl, which
# install_runtime.sh prefers; node:*-slim does not, so it must be installed here.)
RUN --mount=type=cache,id=apt-cache-$TARGETARCH,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lists-$TARGETARCH,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.npm,sharing=locked \
    apt-get update --quiet \
 && apt-get install --quiet --yes --no-install-recommends ca-certificates curl g++ make python3 \
 && npm install --global typescript

# copy the npm pack archives, libskipruntime.so files, and install_runtime.sh
COPY build /work/build

# copy the test code
COPY package.json test.ts /work/

WORKDIR /work

# set installation prefix
ENV PREFIX=/usr/local

# calculate the version of the skipruntime
#   use `npm install --dry-run` (instead of e.g. `npm view`) to respect any version constraints in package.json
RUN VERSION=$(npm install --dry-run @skipruntime/native | grep native | cut -d' ' -f3) \
# specify to obtain the binary release from a local directory
    SOURCE="file:///work/build" \
# specify the installation prefix
    PREFIX=${PREFIX} \
# install the skipruntime binary release
    build/install_runtime.sh \
# install the skipruntime native node addon package
 && npm install @skipruntime/native

# build the test
RUN --mount=type=cache,target=/root/.npm,sharing=locked \
    npm install \
 && tsc --module node16 test.ts

# set LD_LIBRARY_PATH so node can find the native addon's shared object file
ENV LD_LIBRARY_PATH=${PREFIX}/lib

# run the test
CMD ["node", "test.js"]
