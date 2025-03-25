# Deploying a Skip service

The process of setting up and deploying a Skip service is mostly similar to that of other backend systems (databases, caches, etc.) but there are some important nuances to be aware of.

This page walks through those details, or you can refer to [example setups](https://github.com/SkipLabs/skip/tree/main/examples) for representative and complete practical configurations based on standard tooling and components such as Docker, HAProxy, Flask, Express, React, PostgreSQL, and Kafka.

## Overview

Skip reactive services define an HTTP interface for reading, writing, and subscribing to data.
In production use cases for web applications, this should be deployed behind a gateway or reverse proxy such as Kong, Nginx, HAProxy, or Traefik which is responsible for traffic encryption, load balancing, rate limiting, HTTP tunneling, and dispatching requests to backend services.
Throughout this page we will show HAProxy configuration in examples, but it should be directly applicable to other proxies.

Skip is agnostic to your choice of reverse proxy, but it is important that it is configured with HTTP/2 for request/response multiplexing, to avoid browser limitations on concurrent server-sent event connections, and to ensure that TLS is used.

### Running your service

You can build and run your reactive service using Docker Compose and the following `Dockerfile` to expose the necessary ports and initialize the service.
```
FROM node:lts-alpine3.19
WORKDIR /app
COPY package.json package.json
RUN npm install
COPY . .
RUN npm run build
EXPOSE 8080 8081
CMD ["npm", "start"]
```

The `npm start` command will, by default, run your service by executing `./server.js`.
Within that file, you should perform any necessary setup and then spin up the service by calling `runService`; see [here](https://github.com/SkipLabs/skip/tree/main/examples/chatroom/reactive_service/server.js) for an example.

### Data streaming

As described in the documentation for [resources and services](resources.md#resource-http-api), the Skip reactive service HTTP interface exposes control operations on one port and data streaming on another; the default streaming port is `8080` and the default control port is `8081`.
**Important**: Similar to how your database connection should not be exposed to the outside world, your application should expose _only_ the streaming port to the outside world, the control port should be hidden.

Using HAProxy we can restrict and direct traffic as follows:

```
frontend www
	# ...
	acl url_streams path_beg -i /streams/
	use_backend skip if url_streams
	# ...

backend skip
	mode http
	# rewrite public-facing url /streams/... to /v1/streams/... for the Skip server
	http-request set-path /v1%[path]
	server stream reactive_service:8080
```

The `acl` and `use_backend` lines in the frontend configuration forward any traffic at a path beginning with `streams` to the `skip` backend.
Then, that backend rewrites those public-facing urls to the form expected by the reactive service (in this case, just by prepending `/v1`) and specifies the reactive service's address: `reactive_service:8080` here for a service defined as `reactive_service` using Docker Compose and using the default port.
This is a simple "hello world" configuration for a single reactive service; in practice, more involved URL rewriting schemes and ACLs can be employed to orchestrate traffic between multiple public HTTPS endpoints and/or backend reactive services.

### Control operations and reads/writes

The control port of your Skip reactive service should in general only be exposed to other backend services within your secure network, since it allows access to stream creation/deletion and data read/write operations.

This also allows a Skip reactive service to be integrated into your existing web backend(s) -- regardless of their choice of programming language or web framework.
For example, see [here](https://github.com/SkipLabs/skip/tree/main/examples/hackernews/web_service/app.py) for an example Python web app using Flask and backed by a reactive service which it communicates to directly over HTTP using the `requests` library, and [here](https://github.com/SkipLabs/skip/tree/main/skipruntime-ts/examples) (at `*-server.ts`) for a variety of examples in JavaScript using Express.
For JavaScript backends, we also provide a programmatic interface [`SkipServiceBroker`](api/helpers/classes/SkipServiceBroker) which simplifies the integration and obviates the need to construct and manipulate HTTP requests directly.
