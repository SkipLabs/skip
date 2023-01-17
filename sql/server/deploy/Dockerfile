# TODO: should build everything ahead of time
# TODO: the deployment image should just copy over the pre-built and not need any of the dev deps

# we use x86-64 in the cloud
FROM --platform=linux/amd64 ubuntu:20.04
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

RUN apt-get install -y curl zip
# TODO: shouldn't just download a random script from the interwebs :/
RUN sh -c 'curl -s "https://get.sdkman.io?rcupdate=false" | bash'
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install gradle && \
    sdk install java 19.0.1-oracle"

RUN make

WORKDIR /skfs_build/sql/server
CMD ./deploy/start.sh
