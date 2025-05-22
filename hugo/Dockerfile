FROM skiplabs/skdb-base:latest

WORKDIR /skip

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -q -y zsh gdb time vim build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
