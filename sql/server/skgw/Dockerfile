FROM skfs:latest
RUN apt-get update -y
RUN apt-get install -y curl zip
# TODO: shouldn't just download a random script from the interwebs :/
RUN sh -c 'curl -s "https://get.sdkman.io?rcupdate=false" | bash'
RUN bash -c "source /root/.sdkman/bin/sdkman-init.sh && \
    sdk install gradle && \
    sdk install java 19.0.1-oracle"

RUN make && rm sql/target/state.db && rm sql/target/wasm32-unknown-unknown/state.db

CMD ./sql/server/deploy/start.sh
