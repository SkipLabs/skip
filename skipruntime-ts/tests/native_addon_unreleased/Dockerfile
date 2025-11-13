FROM ubuntu:latest

# install dependencies needed to build the node addon
RUN apt-get update --quiet \
 && apt-get install --quiet --yes g++ make python3 wget \
 && wget --quiet --output-document=- https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install --quiet --yes nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && npm install --global typescript

# copy the npm pack archives, libskipruntime.so files, and install_runtime.sh
COPY build /work/build

# copy the test code
COPY package.json test.ts /work/

WORKDIR /work

# calculate the version of the skipruntime
RUN VERSION=$(npm install --dry-run @skipruntime/native | grep native | cut -d' ' -f3) \
# specify to obtain the binary release from a local directory
    SOURCE="file:///work/build" \
# install the skipruntime binary release
    build/install_runtime.sh \
# install the skipruntime native node addon package
 && npm install @skipruntime/native

# build and run the test
RUN npm install
CMD ["bash", "-c", "tsc --module node16 test.ts && LD_LIBRARY_PATH=/usr/local/lib node test.js"]
