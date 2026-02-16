FROM eclipse-temurin:20

# Copy Gradle wrapper and build configs first (changes rarely)
COPY sql/server/gradlew sql/server/gradle.properties /skdb/sql/server/
COPY sql/server/gradle/ /skdb/sql/server/gradle/
COPY sql/server/build.gradle.kts sql/server/settings.gradle.kts /skdb/sql/server/
COPY sql/server/core/build.gradle.kts /skdb/sql/server/core/
COPY sql/server/dev/build.gradle.kts /skdb/sql/server/dev/
COPY sql/server/pg/build.gradle.kts /skdb/sql/server/pg/

WORKDIR /skdb/sql/server/core

# Download dependencies (cached unless build.gradle.kts changes)
RUN --mount=type=cache,target=/root/.gradle,sharing=locked \
    ../gradlew dependencies --no-daemon --console plain

# Copy remaining source
COPY . /skdb

# Build
RUN --mount=type=cache,target=/root/.gradle,sharing=locked \
    ../gradlew build --no-daemon --console plain
