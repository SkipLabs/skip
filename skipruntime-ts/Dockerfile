# Dockerfile to build skipruntime binary release
# see also: ../skiplang/Dockerfile and ../bin/build_runtime.sh

FROM skiplabs/skiplang-bin-builder AS build

# Override at build time with --build-arg SKIP_CAPACITY=<value> to fit the
# build host's memory budget. Empty (the default) preserves the runtime's
# own default: a small initial mapping that grows on demand up to 16 GiB.
ARG SKIP_CAPACITY=
ENV SKIP_CAPACITY=$SKIP_CAPACITY

COPY ./skiplang /work/skiplang
COPY ./skipruntime-ts /work/skipruntime-ts

WORKDIR /work
RUN skargo build --release --lib --manifest-path=skipruntime-ts/skiplang/ffi/Skargo.toml --out-dir=build/skipruntime

FROM scratch
COPY --from=build /work/build/skipruntime/libskipruntime.so /libskipruntime.so
ENTRYPOINT ["/libskipruntime.so"]
