FROM skiplabs/skdb-base as skdb

COPY . /skfs

WORKDIR /skfs

RUN make clean && make build/skdb && make build/init.sql

FROM eclipse-temurin:20 as skgw

COPY . /skfs

WORKDIR /skfs/sql/server/dev
RUN ../gradlew jar --no-daemon --console plain

################################################################################
# Build the development image by copying out artifacts
################################################################################

FROM eclipse-temurin:20 as dev

WORKDIR /skfs

COPY --from=skdb /skfs/build ./build
COPY --from=skgw /skfs/sql/server/dev/build/libs/dev.jar /skfs/build/server.jar
COPY --from=skgw /skfs/sql/server/dev/start_dev.sh /skfs/build/start.sh

ENTRYPOINT ["/skfs/build/start.sh"]
