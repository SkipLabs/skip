FROM eclipse-temurin:20

COPY . /skdb
WORKDIR /skdb/sql/server/core
RUN ../gradlew build --no-daemon --console plain && \
    rm -rf ~/.gradle/caches ~/.gradle/wrapper
