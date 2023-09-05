FROM ubuntu:22.04 as base

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -q -y git make lld sqlite3 gcc gawk clang llvm automake \
    curl jq parallel

# node, typescript, playwright
ENV NODE_MAJOR=20
RUN apt-get install -q -y ca-certificates curl gnupg \
 && mkdir -p /etc/apt/keyrings \
 && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
 && apt-get update \
 && apt-get install -q -y nodejs \
 && npm install -g typescript \
 && npx playwright install-deps

ENV CC=clang
ENV CXX=clang++

FROM base as bootstrap
COPY . /skfs

WORKDIR /skfs/compiler
RUN make install STAGE=0

WORKDIR /skfs
