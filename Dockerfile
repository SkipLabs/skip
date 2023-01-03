FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y git make clang lld-10 sqlite3 gcc gawk
RUN sh -c 'DEBIAN_FRONTEND=noninteractive apt-get install -q -y npm'
RUN npm install -g typescript
COPY . /skfs_build
WORKDIR /skfs_build
RUN mkdir build
RUN gunzip -c prebuild/preamble_and_skc_out64.ll.gz > build/preamble_and_skc_out64.ll
RUN make build/libskip_runtime64.a
RUN clang++ -O3 build/preamble_and_skc_out64.ll build/libskip_runtime64.a -o build/skc -lrt -lpthread
