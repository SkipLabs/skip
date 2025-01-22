FROM ubuntu:22.04 AS stage0

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -q -y wget gnupg && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    wget -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-15 main" >> /etc/apt/sources.list.d/llvm.list && \
    echo "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-15 main" >> /etc/apt/sources.list.d/llvm.list && \
    echo "deb https://deb.nodesource.com/node_22.x nodistro main" >> /etc/apt/sources.list.d/nodejs.list && \
    apt-get update && \
    apt-get install -q -y automake clang-15 clang-format-15 curl file gawk gcc git jq lld-15 llvm-15 make nodejs parallel unzip zip && \
    npm install -g bun && \
    npm install -g prettier

RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 100 && \
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-15 100 && \
    update-alternatives --install /usr/bin/llc llc /usr/bin/llc-15 100 && \
    update-alternatives --install /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-15 100 && \
    update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-15 100 && \
    update-alternatives --install /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-15 100 && \
    update-alternatives --install /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-15 100

ENV CC=clang
ENV CXX=clang++

FROM stage0 AS bootstrap

COPY ./skiplang /work

WORKDIR /work/compiler
RUN make clean && make STAGE=0

FROM stage0 AS base

COPY --from=bootstrap /work/compiler/stage0/bin/ /usr/bin/
COPY --from=bootstrap /work/compiler/stage0/lib/ /usr/lib/
