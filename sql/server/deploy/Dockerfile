################################################################################
# Build the artifacts
################################################################################

# we use x86-64 in the cloud so we need to duplicate the build steps
# here - we can't reuse existing images that might be arm64
FROM --platform=linux/amd64 skiplabs/skdb-base as skdb

COPY . /skdb

WORKDIR /skdb

RUN make clean && make build/skdb && make build/init.sql

# we use native for skgw as gradle does NOT like being emulated and
# this is faster anyway
FROM eclipse-temurin:20 as skgw

COPY . /skdb

WORKDIR /skdb/sql/server/skgw
RUN ../gradlew jar --no-daemon --console plain

################################################################################
# Build the production image by copying out artifacts
################################################################################

FROM --platform=linux/amd64 eclipse-temurin:20 as prod

WORKDIR /skdb

COPY --from=skdb /skdb/build ./build
COPY --from=skgw /skdb/sql/server/skgw/build/libs/skgw.jar /skdb/build/server.jar
COPY --from=skgw /skdb/sql/server/deploy/start_prod.sh /skdb/build/start.sh

CMD /skdb/build/start.sh
