################################################################################
# Build the artifacts
################################################################################

# we use x86-64 in the cloud so we need to duplicate the build steps
# here - we can't reuse existing images that might be arm64
FROM --platform=linux/amd64 ubuntu:20.04 as build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -q -y git make lld sqlite3 gcc gawk clang llvm automake-1.15 \
    curl zip

ENV CC=clang
ENV CXX=clang++

COPY . /skfs

WORKDIR /skfs/compiler
RUN make -B install STAGE=0

WORKDIR /skfs

RUN make clean && make -B build/skdb && make -B build/init.sql

RUN sh -c 'curl -s "https://get.sdkman.io?rcupdate=false" | bash'
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && sdk install java 19.0.1-oracle"

WORKDIR /skfs/sql/server/skgw
ENV JAVA_HOME=/root/.sdkman/candidates/java/current
RUN ./gradlew jar --no-daemon --console plain

################################################################################
# Build the production image
################################################################################

FROM --platform=linux/amd64 ubuntu:22.04 as prod

WORKDIR /skfs

COPY --from=build /skfs/build ./
COPY --from=build /skfs/sql/server/skgw/app/build/libs/app.jar /skfs/build/server.jar
COPY --from=build /root/.sdkman /root/

CMD /root/.sdkman/candidates/java/current/bin/java -jar /skfs/build/server.jar
