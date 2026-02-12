FROM ubuntu:latest

# install dependencies needed to build the node addon
RUN apt-get update --quiet \
 && apt-get install --quiet --yes g++ make python3 wget \
 && wget --quiet --output-document=- https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install --quiet --yes nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && npm install --global typescript \
 && npm cache clean --force

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
RUN npm install \
 && tsc --module node16 test.ts \
 && npm cache clean --force

# set LD_LIBRARY_PATH so node can find the native addon's shared object file
ENV LD_LIBRARY_PATH=${PREFIX}/lib

# run the test
CMD ["node", "test.js"]
