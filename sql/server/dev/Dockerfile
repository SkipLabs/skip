FROM skiplabs/skdb-base as skdb
FROM eclipse-temurin:20 as skgw

COPY . /skdb

WORKDIR /skdb/sql/server/dev
RUN ../gradlew jar --no-daemon --console plain

################################################################################
# Build the development image by copying out artifacts
################################################################################

FROM eclipse-temurin:20 as dev

WORKDIR /skdb

COPY --from=skgw /skdb/sql/server/dev/build/libs/dev.jar /skdb/build/server.jar
COPY --from=skgw /skdb/sql/server/dev/start_dev.sh /skdb/build/start.sh

ENTRYPOINT ["/skdb/build/start.sh"]
