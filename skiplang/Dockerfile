# skiplabs/skiplang-bin-builder
# Dockerfile to build skiplang toolchain to build binary releases

# aim to start from an image with a version of glibc that is as widely
# compatible as possible while still receiving security updates
FROM debian:bookworm-20250113-slim AS base

ARG LLVM_VERSION=20
ARG TARGETARCH

# Install LLVM via apt repository with signed GPG key
RUN --mount=type=cache,id=apt-cache-$TARGETARCH,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lists-$TARGETARCH,target=/var/lib/apt/lists,sharing=locked \
    apt-get update --quiet && \
    apt-get install --quiet --yes --no-install-recommends ca-certificates make wget && \
    mkdir -p /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/llvm.asc https://apt.llvm.org/llvm-snapshot.gpg.key && \
    echo "deb [signed-by=/etc/apt/keyrings/llvm.asc] http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-${LLVM_VERSION} main" > /etc/apt/sources.list.d/llvm.list && \
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

COPY --link --from=skiplang /work/skiplang/compiler/stage0/bin/ /usr/bin/
COPY --link --from=skiplang /work/skiplang/compiler/stage0/lib/ /usr/lib/
