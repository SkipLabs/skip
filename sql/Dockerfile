FROM skiplabs/skip AS base

ARG TARGETARCH

# Install system deps, Java 20 (Adoptium Temurin), and Gradle 9.3.1
RUN --mount=type=cache,id=apt-cache-$TARGETARCH,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lists-$TARGETARCH,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.npm,sharing=locked \
    mkdir -p /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/adoptium.asc https://packages.adoptium.net/artifactory/api/gpg/key/public && \
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo $VERSION_CODENAME) main" \
      > /etc/apt/sources.list.d/adoptium.list && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends curl sqlite3 unzip zip temurin-20-jdk && \
    npm install -g bun && \
    npx playwright install-deps && \
    curl -sL https://services.gradle.org/distributions/gradle-9.3.1-bin.zip -o /tmp/gradle.zip && \
    unzip -q /tmp/gradle.zip -d /opt && \
    rm /tmp/gradle.zip && \
    ln -s /opt/gradle-9.3.1/bin/gradle /usr/local/bin/gradle && \
    mkdir -p /root/.sdkman/bin \
      /root/.sdkman/candidates/java/20.0.2-tem \
      /root/.sdkman/candidates/gradle && \
    touch /root/.sdkman/bin/sdkman-init.sh

ENV JAVA_HOME=/usr/lib/jvm/temurin-20-jdk-${TARGETARCH}

FROM base AS skdb

COPY . /skdb

WORKDIR /skdb

RUN make clean && make -C skiplang/compiler clean && make build/skdb && make build/init.sql
