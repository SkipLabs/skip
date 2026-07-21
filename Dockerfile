FROM ubuntu:24.04 AS skiplang-base

ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=bind,source=./bin/apt-install.sh,target=/tmp/apt-install.sh \
    --mount=type=cache,id=apt-cache-$TARGETARCH,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lists-$TARGETARCH,target=/var/lib/apt/lists,sharing=locked \
    /tmp/apt-install.sh skiplang-build-deps

ENV CC=clang
ENV CXX=clang++

# Override at build time with --build-arg SKIP_CAPACITY=<value> to fit the
# build host's memory budget. Empty (the default) preserves the runtime's
# own 16 GB default for local dev builds.
ARG SKIP_CAPACITY=
ENV SKIP_CAPACITY=$SKIP_CAPACITY

FROM skiplang-base AS bootstrap

ARG STAGE=0
COPY ./skiplang /work

WORKDIR /work/compiler
RUN make clean && make STAGE=$STAGE

FROM skiplang-base AS skiplang

ARG STAGE=0
COPY --link --from=bootstrap /work/compiler/stage${STAGE}/bin/ /usr/bin/
COPY --link --from=bootstrap /work/compiler/stage${STAGE}/lib/ /usr/lib/

FROM skiplang AS skip

RUN --mount=type=bind,source=./bin/apt-install.sh,target=/tmp/apt-install.sh \
    --mount=type=bind,source=./requirements-dev.txt,target=/tmp/requirements-dev.txt \
    --mount=type=cache,id=apt-cache-$TARGETARCH,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lists-$TARGETARCH,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.npm,sharing=locked \
    --mount=type=cache,target=/root/.cache/pip,sharing=locked \
    /tmp/apt-install.sh skipruntime-deps other-CI-tools other-dev-tools
