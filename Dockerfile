FROM --platform=linux/amd64 ubuntu:20.04
RUN apt-get update
RUN apt-get install -y git make clang lld-10 sqlite3 gcc gawk
COPY . /skfs_build
WORKDIR /skfs_build
RUN mkdir build
RUN gunzip -c prebuild/preamble_and_skc_out64.ll.gz > build/preamble_and_skc_out64.ll
RUN make build/libskip_runtime64.a
RUN clang++ -O3 build/preamble_and_skc_out64.ll build/libskip_runtime64.a -o build/skc -lrt -lpthread
