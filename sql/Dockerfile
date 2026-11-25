FROM skiplabs/skip AS base

ARG TARGETARCH

# Install system deps, Java 21 (Adoptium Temurin), and Gradle 9.6.1.
# The .sdkman stub dirs below are a build-time sentinel that lets
# sql/ts/tests/service_common.mk skip its SDKMAN install (Java here comes
# from apt above). Its version string only has to match that Makefile — it
# does not track the JDK version and is intentionally left at 20.0.2-tem.
#
# Gradle has no apt repository, so the distribution zip is downloaded over
# the network: pin its SHA256 and verify before unpacking, so a compromised
# mirror cannot feed the image a tampered archive. To update the pin when
# bumping the Gradle version: ./bin/update_docker_checksums.sh --apply
ARG GRADLE_SHA256=9c0f7faeeb306cb14e4279a3e084ca6b596894089a0638e68a07c945a32c9e14
RUN --mount=type=cache,id=apt-cache-$TARGETARCH,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lists-$TARGETARCH,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.npm,sharing=locked \
    mkdir -p /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public && \
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo $VERSION_CODENAME) main" \
      > /etc/apt/sources.list.d/adoptium.list && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends curl sqlite3 unzip zip temurin-21-jdk && \
    npm install -g bun && \
    npx playwright install-deps && \
    curl -sL https://services.gradle.org/distributions/gradle-9.6.1-bin.zip -o /tmp/gradle.zip && \
    echo "${GRADLE_SHA256}  /tmp/gradle.zip" | sha256sum -c - && \
    unzip -q /tmp/gradle.zip -d /opt && \
    rm /tmp/gradle.zip && \
    ln -s /opt/gradle-9.6.1/bin/gradle /usr/local/bin/gradle && \
    mkdir -p /root/.sdkman/bin \
      /root/.sdkman/candidates/java/20.0.2-tem \
      /root/.sdkman/candidates/gradle && \
    touch /root/.sdkman/bin/sdkman-init.sh

ENV JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-${TARGETARCH}

FROM base AS skdb

COPY . /skdb

WORKDIR /skdb

RUN make clean && make -C skiplang/compiler clean && make build/skdb && make build/init.sql
