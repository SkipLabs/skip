FROM skiplabs/skip AS base

ARG TARGETARCH

RUN --mount=type=cache,id=apt-cache-$TARGETARCH,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=apt-lists-$TARGETARCH,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/root/.npm,sharing=locked \
    apt-get update && apt-get install -q -y --no-install-recommends curl sqlite3 unzip zip && \
    npm install -g bun && \
    npx playwright install-deps

RUN sh -c 'curl -s "https://get.sdkman.io?rcupdate=false" | bash'
RUN --mount=type=cache,id=sdkman-$TARGETARCH,target=/root/.sdkman/archives,sharing=locked \
    bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    sdk install gradle && \
    sdk install java 20.0.2-tem"

FROM base AS skdb

COPY . /skdb

WORKDIR /skdb

RUN make clean && make -C skiplang/compiler clean && make build/skdb && make build/init.sql
