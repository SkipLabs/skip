FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y git make clang
COPY . /skfs_build
WORKDIR /skfs_build
RUN mkdir build
RUN gunzip -c prebuild/preamble_and_skc_out64.ll.gz > build/preamble_and_skc_out64.ll
RUN make build/libskip_runtime64.a
RUN clang++ -O3 build/preamble_and_skc_out64.ll build/libskip_runtime64.a -o build/skc -lrt -lpthread
RUN make -C tests
