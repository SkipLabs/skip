FROM ubuntu:22.04 as base

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -q -y git make lld sqlite3 gcc gawk clang llvm automake \
    curl jq parallel
RUN apt-get install -q -y libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 libatspi2.0-0 libxdamage1 libgbm1 libpango-1.0-0 libcairo2 libxcomposite1 libxfixes3 libxrandr2 libgtk-3-0 libpangocairo-1.0-0 libcairo-gobject2 libgdk-pixbuf2.0-0 libdbus-glib-1-2 libx11-xcb1 libxcursor1 libxi6 libasound2 \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -q -y nodejs \
    && npm install -g typescript

ENV CC=clang
ENV CXX=clang++

FROM base as bootstrap
COPY . /skfs

WORKDIR /skfs/compiler
RUN make install STAGE=0

WORKDIR /skfs
