FROM skiplabs/skdb AS skdb
FROM eclipse-temurin:20 AS skgw

# Copy Gradle wrapper and build configs first (changes rarely)
COPY sql/server/gradlew sql/server/gradle.properties /skdb/sql/server/
COPY sql/server/gradle/ /skdb/sql/server/gradle/
COPY sql/server/build.gradle.kts sql/server/settings.gradle.kts /skdb/sql/server/
COPY sql/server/core/build.gradle.kts /skdb/sql/server/core/
COPY sql/server/dev/build.gradle.kts /skdb/sql/server/dev/
COPY sql/server/pg/build.gradle.kts /skdb/sql/server/pg/

WORKDIR /skdb/sql/server/dev

# Download dependencies (cached unless build.gradle.kts changes)
RUN --mount=type=cache,target=/root/.gradle,sharing=locked \
    ../gradlew dependencies --no-daemon --console plain

# Copy remaining source
COPY . /skdb

# Build
RUN --mount=type=cache,target=/root/.gradle,sharing=locked \
    ../gradlew jar --no-daemon --console plain

################################################################################
# Build the development image by copying out artifacts
################################################################################

FROM eclipse-temurin:20 AS dev

WORKDIR /skdb

COPY --link --from=skdb /skdb/build ./build
COPY --link --from=skgw /skdb/sql/server/dev/build/libs/dev.jar /skdb/build/server.jar
COPY --link --from=skgw /skdb/sql/server/dev/start_dev.sh /skdb/build/start.sh

ENTRYPOINT ["/skdb/build/start.sh"]
