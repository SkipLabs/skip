FROM ubuntu:20.04 as base
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -q -y npm git make lld sqlite3 gcc gawk clang llvm automake-1.15
RUN update-alternatives --install /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-10 100
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs
RUN npm install -g typescript

ENV CC=clang
ENV CXX=clang++

FROM base as bootstrap
COPY . /skfs

WORKDIR /skfs/compiler
RUN make install STAGE=0

WORKDIR /skfs
