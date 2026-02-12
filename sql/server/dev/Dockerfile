FROM skiplabs/skdb AS skdb
FROM eclipse-temurin:20 AS skgw

COPY . /skdb

WORKDIR /skdb/sql/server/dev
RUN --mount=type=cache,target=/root/.gradle,sharing=locked \
    ../gradlew jar --no-daemon --console plain

################################################################################
# Build the development image by copying out artifacts
################################################################################

FROM eclipse-temurin:20 AS dev

WORKDIR /skdb

COPY --from=skdb /skdb/build ./build
COPY --from=skgw /skdb/sql/server/dev/build/libs/dev.jar /skdb/build/server.jar
COPY --from=skgw /skdb/sql/server/dev/start_dev.sh /skdb/build/start.sh

ENTRYPOINT ["/skdb/build/start.sh"]
