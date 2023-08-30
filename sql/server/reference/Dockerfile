FROM ubuntu:20.04 as skdb

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -q -y git make lld sqlite3 gcc gawk clang llvm automake-1.15 \
    curl zip

ENV CC=clang
ENV CXX=clang++

COPY . /skfs

WORKDIR /skfs/compiler
RUN make -B install STAGE=0

WORKDIR /skfs

RUN make clean && make -B build/skdb && make -B build/init.sql

FROM eclipse-temurin:19 as skgw

COPY . /skfs

WORKDIR /skfs/sql/server/reference
RUN ../gradlew jar --no-daemon --console plain

################################################################################
# Build the production image by copying out artifacts
################################################################################

FROM eclipse-temurin:19 as prod

WORKDIR /skfs

COPY --from=skdb /skfs/build ./build
COPY --from=skgw /skfs/sql/server/reference/build/libs/reference.jar /skfs/build/server.jar
COPY --from=skgw /skfs/sql/server/deploy/start_prod.sh /skfs/build/start.sh

ENTRYPOINT ["/skfs/build/start.sh"]
