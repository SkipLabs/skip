# Reactive HackerNews example

This example is made of a Skip reactive service (in `reactive_service/`), a
Flask web service (in `web_service/`), a React front-end (in `www/`), a HAProxy
reverse-proxy (in `reverse_proxy/`), and a PostgreSQL database (in `db/`).

In order to run it, do:
```
$ docker compose up --build
```

In addition to the default configuration which runs a single Skip service, this
example can also run the Skip service in a distributed *leader-follower*
configuration, with one *leader* handling writes and talking to the Postgres DB,
and three *followers* which serve reactive streams to clients, sharing the load
of computing and maintaining resources in a round-robin fashion.

This distributed configuration requires only configuration changes, is
transparent to clients, and can be run with:
```
$ docker compose -f compose.distributed.yml up --build
```
