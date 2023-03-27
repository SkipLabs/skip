FROM cimg/base:current-20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN sudo apt-get update
RUN sudo apt-get -y install git curl make lld sqlite3 gcc gawk clang llvm npm
RUN sudo npm install -g typescript
RUN sudo update-alternatives --install /usr/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-10 100
