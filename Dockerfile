FROM ubuntu:22.04 AS skiplang-base

ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=bind,source=./bin/apt-install.sh,target=/tmp/apt-install.sh \
    /tmp/apt-install.sh skiplang-build-deps

ENV CC=clang
ENV CXX=clang++

FROM skiplang-base AS bootstrap

COPY ./skiplang /work

WORKDIR /work/compiler
RUN make clean && make STAGE=0

FROM skiplang-base AS skiplang

COPY --from=bootstrap /work/compiler/stage0/bin/ /usr/bin/
COPY --from=bootstrap /work/compiler/stage0/lib/ /usr/lib/

FROM skiplang AS skip

RUN --mount=type=bind,source=./bin/apt-install.sh,target=/tmp/apt-install.sh \
    /tmp/apt-install.sh skipruntime-deps other-CI-tools
