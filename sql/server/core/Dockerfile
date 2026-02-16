FROM eclipse-temurin:20

COPY . /skdb
WORKDIR /skdb/sql/server/core
RUN --mount=type=cache,target=/root/.gradle,sharing=locked \
    ../gradlew build --no-daemon --console plain
