FROM ubuntu:latest

# install dependencies needed to build the node addon
RUN apt-get update --quiet \
 && apt-get install --quiet --yes g++ make python3 wget \
 && wget --quiet --output-document=- https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install --quiet --yes nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && npm install --global typescript

# copy the test code
COPY package.json test.ts /work/

WORKDIR /work

# calculate the version of the skipruntime
#   use `npm install --dry-run` (instead of e.g. `npm view`) to respect any version constraints in package.json
RUN VERSION=$(npm install --dry-run @skipruntime/native | grep native | cut -d' ' -f3) \
# install the skipruntime binary release
 && wget --quiet --output-document=- \
      https://raw.githubusercontent.com/skiplabs/skip/refs/tags/v${VERSION}/bin/install_runtime.sh \
  | VERSION=${VERSION} bash - \
# install the skipruntime native node addon package
 && npm install @skipruntime/native

# build and run the test
RUN npm install
CMD ["bash", "-c", "tsc --module node16 test.ts && LD_LIBRARY_PATH=/usr/local/lib node test.js"]
