# skiplabs/skiplang-bin-builder
# Dockerfile to build skiplang toolchain to build binary releases

# aim to start from an image with a version of glibc that is as widely
# compatible as possible while still receiving security updates
FROM debian:bookworm-20250113-slim AS base

ARG LLVM_VERSION=20

# Install LLVM via apt repository directly
# Note: [trusted=yes] is needed because apt.llvm.org's GPG key uses SHA1 signatures
# which modern Debian rejects since Feb 2026. This is an upstream LLVM issue.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    apt-get update --quiet && \
    apt-get install --quiet --yes --no-install-recommends ca-certificates make wget && \
    echo "deb [trusted=yes] http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-${LLVM_VERSION} main" > /etc/apt/sources.list.d/llvm.list && \
    apt-get update --quiet && \
    apt-get install --quiet --yes --no-install-recommends \
        clang-${LLVM_VERSION} \
        llvm-${LLVM_VERSION} \
        lld-${LLVM_VERSION} && \
    update-alternatives \
      --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 101 \
      --slave /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} \
      --slave /usr/bin/llc llc /usr/bin/llc-${LLVM_VERSION} \
      --slave /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-${LLVM_VERSION} \
      --slave /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-${LLVM_VERSION} \
      --slave /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-${LLVM_VERSION} \
      --slave /usr/bin/opt opt /usr/bin/opt-${LLVM_VERSION}

ENV CC=clang
ENV CXX=clang++

FROM base AS skiplang

COPY ./skiplang /work/skiplang

WORKDIR /work/skiplang/compiler
RUN make clean && make STAGE=0

FROM base AS final

COPY --from=skiplang /work/skiplang/compiler/stage0/bin/ /usr/bin/
COPY --from=skiplang /work/skiplang/compiler/stage0/lib/ /usr/lib/
