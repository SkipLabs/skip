# Node comes baked into the base image. Bookworm matches the glibc floor (2.36)
# of the debian:bookworm image that builds the released libskipruntime.so, so the
# downloaded .so loads. Deliberately NOT `ubuntu:latest` + a nodesource apt repo:
# that pulled Node over the network on every run and, under an ephemeral Docker
# daemon, balloons whenever those mirrors are slow (see #1470).
FROM node:22.13.1-bookworm-slim

ARG TARGETARCH

# Install only the node-gyp toolchain (g++, make, python3), CA certificates, and
# wget -- used below and by install_runtime.sh to fetch over HTTPS. (Unlike the
# native_addon_unreleased variant, which copies the .so from a file:// source and
# so needs curl, these are https:// downloads, which wget handles.)
RUN --mount=type=cache,id=apt-cache-$TARGETARCH,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lists-$TARGETARCH,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.npm,sharing=locked \
    apt-get update --quiet \
 && apt-get install --quiet --yes --no-install-recommends ca-certificates g++ make python3 wget \
 && npm install --global typescript

# copy the test code
COPY package.json test.ts /work/

WORKDIR /work

# set installation prefix
ENV PREFIX=/usr/local

# calculate the version of the skipruntime
#   use `npm install --dry-run` (instead of e.g. `npm view`) to respect any version constraints in package.json
RUN VERSION=$(npm install --dry-run @skipruntime/native | grep native | cut -d' ' -f3) \
# install the skipruntime binary release
 && wget --quiet --output-document=- \
      https://raw.githubusercontent.com/skiplabs/skip/refs/tags/v${VERSION}/bin/install_runtime.sh \
  | VERSION=${VERSION} PREFIX=${PREFIX} bash - \
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
