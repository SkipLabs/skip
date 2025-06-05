# Dockerfile to build skipruntime binary release
# see also: skip/bin/build_runtime.sh

FROM debian:stable-slim AS base

RUN apt-get update --quiet
RUN apt-get install --quiet --yes clang-15 make
RUN update-alternatives \
      --install /usr/bin/clang clang /usr/bin/clang-15 101 \
      --slave /usr/bin/clang++ clang++ /usr/bin/clang++-15 \
      --slave /usr/bin/llc llc /usr/bin/llc-15 \
      --slave /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-15 \
      --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-15 \
      --slave /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-15

ENV CC=clang
ENV CXX=clang++

FROM base AS skiplang

COPY ./skiplang /work/skiplang

WORKDIR /work/skiplang/compiler
RUN make clean && make STAGE=0

FROM base AS build

COPY --from=skiplang /work/skiplang/compiler/stage0/bin/ /usr/bin/
COPY --from=skiplang /work/skiplang/compiler/stage0/lib/ /usr/lib/

COPY ./skiplang /work/skiplang
COPY ./skipruntime-ts /work/skipruntime-ts

WORKDIR /work
RUN skargo clean --manifest-path=skipruntime-ts/skiplang/ffi/Skargo.toml
RUN skargo build --release --lib --manifest-path=skipruntime-ts/skiplang/ffi/Skargo.toml --out-dir=build/skipruntime

FROM scratch
COPY --from=build /work/build/skipruntime/libskipruntime.so /libskipruntime.so
ENTRYPOINT ["/libskipruntime.so"]
