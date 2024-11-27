# Client connections

Clients can subscribe to updates from a reactive service using the widely-available [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events) protocol, or make synchronous read requests for specific data.
This means that Skip clients are thin and lightweight: all major browsers implement the requisite `EventSource` interface, and other types of clients can easily implement parsers for the simple text-based protocol.

Note that this page describes mechanisms for front-end clients or non-Skip systems to access the outputs of a Skip service; to communicate among Skip services it is both simpler and more efficient to use [external dependencies](todo: docusaurus link).

By design, client code does not need to import or reason about the internal details of Skip reactive services; this page abstracts over those details, but for completeness's sake we provide a simple explanatory example [below](todo: intrapage link to "Example web service configuration") of a backend service which can support such clients.

## Event Streams

## Synchronous HTTP interface

# Example web service configuration

Skip reactive services instantiate resources on request, generating a unique UUID for each unique query and serving the resulting stream of updates over HTTP.
Managing these UUIDs is straightforward, but is best done using a traditional web service to request stream UUIDs and transparently redirect clients to their data.

A simple explanatory example is given here using the [Express](https://expressjs.com) web framework, but any web framework will do -- Skip is designed to work over HTTP with whatever backend framework you like.

```typescript
import express from "express";
const app = express();
app.use(express.json());

// Specify the reactive service's address
const reactive_host = "reactive.service.hostname";
const streaming_port = 8080;
const control_port = 8081;
const reactive_service = new SkipServiceBroker({
  host: reactive_host,
  streaming_port,
  control_port,
});

// On receiving a GET request for a resource instance,
//  1. Parse out any params from the request
//  2. Request a stream identifier with those parameters from the reactive service
//  3. Redirect the client to the corresponding stream address
app.get("/my_resource/:id", (req, res) => {
  const params = { id: req.params.id, foo: req.params.bar, ...};
  reactive_service
    .getStreamUUID("my_resource", params)
    .then((uuid) => {
      res.redirect(301, `http://${reactive_host}:${streaming_port}/v1/streams/${uuid}`);
    })
});
```

