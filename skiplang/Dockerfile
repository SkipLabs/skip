# skiplabs/skiplang-bin-builder
# Dockerfile to build skiplang toolchain to build binary releases

# aim to start from an image with a version of glibc that is as widely
# compatible as possible while still receiving security updates
FROM debian:stable-slim AS base

ARG LLVM_VERSION=20

RUN apt-get update --quiet
RUN apt-get install --quiet --yes gnupg lsb-release make software-properties-common wget
RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh ${LLVM_VERSION} && \
    rm llvm.sh && \
    update-alternatives \
      --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 101 \
      --slave /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} \
      --slave /usr/bin/llc llc /usr/bin/llc-${LLVM_VERSION} \
      --slave /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-${LLVM_VERSION} \
      --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-${LLVM_VERSION} \
      --slave /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-${LLVM_VERSION}

ENV CC=clang
ENV CXX=clang++

FROM base AS skiplang

COPY ./skiplang /work/skiplang

WORKDIR /work/skiplang/compiler
RUN make clean && make STAGE=0

FROM base AS final

COPY --from=skiplang /work/skiplang/compiler/stage0/bin/ /usr/bin/
COPY --from=skiplang /work/skiplang/compiler/stage0/lib/ /usr/lib/
