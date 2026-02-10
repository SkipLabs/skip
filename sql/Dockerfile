FROM skiplabs/skip AS base

RUN apt-get update && apt-get install -q -y curl sqlite3 unzip zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN npm install -g bun && npm cache clean --force
RUN npx playwright install-deps && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sh -c 'curl -s "https://get.sdkman.io?rcupdate=false" | bash'
RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    sdk install gradle && \
    sdk install java 20.0.2-tem && \
    rm -rf $HOME/.sdkman/archives/*"

FROM base AS skdb

COPY . /skdb

WORKDIR /skdb

RUN make clean && make -C skiplang/compiler clean && make build/skdb && make build/init.sql
