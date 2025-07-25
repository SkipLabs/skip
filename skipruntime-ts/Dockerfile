# Dockerfile to build skipruntime binary release
# see also: ../skiplang/Dockerfile and ../bin/build_runtime.sh

FROM skiplabs/skiplang-bin-builder AS build

COPY ./skiplang /work/skiplang
COPY ./skipruntime-ts /work/skipruntime-ts

WORKDIR /work
RUN skargo build --release --lib --manifest-path=skipruntime-ts/skiplang/ffi/Skargo.toml --out-dir=build/skipruntime

FROM scratch
COPY --from=build /work/build/skipruntime/libskipruntime.so /libskipruntime.so
ENTRYPOINT ["/libskipruntime.so"]
