FROM cimg/base:current-20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update \
    && sudo apt-get -y install git make lld sqlite3 gcc gawk clang llvm \
    curl \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxkbcommon0 libatspi2.0-0 libxdamage1 libgbm1 libpango-1.0-0 libcairo2 libxcomposite1 libxfixes3 libxrandr2 libgtk-3-0 libpangocairo-1.0-0 libcairo-gobject2 libgdk-pixbuf2.0-0 libdbus-glib-1-2 libx11-xcb1 libxcursor1 libxi6 libasound2 \
    && sudo update-alternatives --install /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-10 100 \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt-get install -y nodejs \
    && sudo npm install -g typescript
