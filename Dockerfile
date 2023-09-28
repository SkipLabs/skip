FROM ubuntu:22.04 as base

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -q -y wget gnupg && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    wget -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-15 main" >> /etc/apt/sources.list.d/llvm.list && \
    echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-15 main" >> /etc/apt/sources.list.d/llvm.list && \
    echo "deb https://deb.nodesource.com/node_20.x nodistro main" >> /etc/apt/sources.list.d/nodejs.list && \
    apt update && \
    apt install -q -y git zip unzip make lld-15 sqlite3 gcc gawk clang-15 llvm-15 automake jq parallel nodejs && \
    npm install -g typescript@5.1 && \
    npx playwright install-deps

RUN update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-15 100 && \
    update-alternatives --install /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-15 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 100 && \
    update-alternatives --install /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-15 100 && \
    update-alternatives --install /usr/bin/llc llc /usr/bin/llc-15 100

ENV CC=clang
ENV CXX=clang++

FROM base as bootstrap
COPY . /skfs

WORKDIR /skfs/compiler
RUN make install STAGE=0

WORKDIR /skfs
