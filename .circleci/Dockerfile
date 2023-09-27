FROM --platform=amd64 ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install -y wget gnupg && \
    echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-15 main" >> /etc/apt/sources.list.d/llvm.list && \
    echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-15 main" >> /etc/apt/sources.list.d/llvm.list && \
    echo "deb https://deb.nodesource.com/node_20.x nodistro main" >> /etc/apt/sources.list.d/nodejs.list && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    wget -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | apt-key add - && \
    apt update && \
    apt install -y git make lld-15 sqlite3 gcc gawk clang-15 llvm-15 \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 libatspi2.0-0 libxdamage1 libgbm1 libpango-1.0-0 libcairo2 libxcomposite1 libxfixes3 libxrandr2 libgtk-3-0 libpangocairo-1.0-0 libcairo-gobject2 libgdk-pixbuf2.0-0 libdbus-glib-1-2 libx11-xcb1 libxcursor1 libxi6 libasound2 nodejs && \
    npm install -g typescript

RUN update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-15 100 && \
    update-alternatives --install /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-15 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-15 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-15 100 && \
    update-alternatives --install /usr/bin/llvm-link llvm-link /usr/bin/llvm-link-15 100 && \
    update-alternatives --install /usr/bin/llc llc /usr/bin/llc-15 100

ENV CC=clang
ENV CXX=clang++
