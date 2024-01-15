FROM skiplabs/skdb-base as skdb

COPY . /skdb

WORKDIR /skdb

RUN make clean && make -C compiler clean && make build/skdb && make build/init.sql

