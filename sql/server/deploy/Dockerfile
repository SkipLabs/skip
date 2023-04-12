# TODO: should build everything ahead of time
# TODO: the deployment image should just copy over the pre-built and not need any of the dev deps

# we use x86-64 in the cloud
FROM --platform=linux/amd64 ubuntu:20.04 as base
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -q -y npm git make lld sqlite3 gcc gawk clang llvm automake-1.15
RUN update-alternatives --install /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-10 100
RUN npm install -g typescript

ENV CC=clang
ENV CXX=clang++

FROM base as bootstrap
COPY . /skfs

WORKDIR /skfs/compiler
RUN make -B install STAGE=0

WORKDIR /skfs

RUN apt-get install -y curl zip
# TODO: shouldn't just download a random script from the interwebs :/
RUN sh -c 'curl -s "https://get.sdkman.io?rcupdate=false" | bash'
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install gradle && \
    sdk install java 19.0.1-oracle"

RUN make clean
RUN make -B && rm sql/target/state.db && rm sql/target/wasm32-unknown-unknown/state.db

CMD ./sql/server/deploy/start.sh
