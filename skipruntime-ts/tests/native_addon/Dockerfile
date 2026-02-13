FROM ubuntu:latest

# install dependencies needed to build the node addon
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.npm,sharing=locked \
    apt-get update --quiet \
 && apt-get install --quiet --yes --no-install-recommends g++ make python3 wget \
 && wget --quiet --output-document=- https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install --quiet --yes --no-install-recommends nodejs \
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
