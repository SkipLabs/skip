# Reactive chat room example

This example is made of three parts: the skip reactive service (in
`reactive_service/`), the web service (in `web_service/`), and the front-end (in
`www/`).

It is meant to serve as an example configuration of a web service with a Kafka
event-store serving as the primary data source-of-truth and a Skip reactive
service providing reactive computations and real-time streaming to clients.

In order to run it, do:

```
$ docker compose build
$ docker compose up
```
