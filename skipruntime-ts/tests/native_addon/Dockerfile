FROM ubuntu:latest

# install dependencies needed to build the node addon
RUN apt-get update --quiet \
 && apt-get install --quiet --yes curl make g++ python3 \
 && curl --fail --silent --show-error --location https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install --quiet --yes nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && npm install --global typescript

# copy the test code
COPY package.json /work/package.json
COPY test.ts /work/test.ts

WORKDIR /work

# install (only) @skipruntime/core first to be able to query its version
RUN npm install @skipruntime/core --ignore-scripts \
# calculate the corresponding version of the skipruntime
 && VERSION=$(npm list @skipruntime/core --depth=0 | grep @skipruntime/core | sed 's/.*@//') \
# install the skipruntime binary release
 && curl --fail --silent --show-error --location \
      https://raw.githubusercontent.com/skiplabs/skip/refs/tags/v${VERSION}/bin/install_runtime.sh \
  | bash -

# build and run the test code
RUN npm install
CMD ["bash", "-c", "tsc --module node16 test.ts && LD_LIBRARY_PATH=/usr/local/lib node test.js"]
