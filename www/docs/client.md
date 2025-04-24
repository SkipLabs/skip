# Client connections

Clients can subscribe to updates from a reactive service using the widely-available [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events) protocol, or make synchronous read requests for specific data.
This means that Skip clients are thin and lightweight: the JavaScript `EventSource` interface is widely implemented, and other types of clients can easily implement parsers for the simple text-based protocol.

Note that this page describes mechanisms for front-end clients or non-Skip systems to access the outputs of a Skip service; to communicate among Skip services it is both simpler and more efficient to use [external dependencies](externals.md).

By design, client code does not need to import or reason about the internal details of Skip reactive services; this page abstracts over those details, but for completeness's sake we provide a simple explanatory example [below](client.md#example-web-service-configuration) of a backend service which can support such clients.

## Event streams

Clients of reactive services can opt to receive pushed data updates using HTTP server-sent events.

The simplest way to see the data that your client will receive is to use `curl`, e.g. `curl -LN http://reactive.service.hostname/my_resource/foo` to stream from `my_resource` with parameter `foo`, which will produce output like the following for the example service [below](client.md#example-web-service-configuration):

```
event: init
id: 1065359156
data: [["key1",["value1"]],["key2",["value2","value3"]]]

event: update
id: 1065376268
data: [["key2",["value2"]]]

event: update
id: 1065371604
data: [["key3",["value4"]]]
```

The `init` event contains all available data for the resource when the connection is created, and can be used to set up initial client state.

Subsequent `update` events indicate changes _only_ at the included keys: the first update here removes `"value3"` from `"key2"`, while the second adds a new entry associating `"key3"` to `"value4"`.

All events include an `id` metadata field which should mostly be ignored, but can be useful for debugging, replay, and similar purposes.

In practice, client apps don't need to interact with this raw data stream: JavaScript provides a useful `EventSource` interface to maintain the connection and register event-handler callbacks.

```typescript
const stream = new EventSource("http://reactive.service.hostname/my_resource/foo");
stream.addEventListener("init", (e: MessageEvent<string>) => {
  const initial_data = JSON.parse(e.data);
  console.log("Initial data: ", initial_data);
});
stream.addEventListener("update", (e: MessageEvent<string>) => {
  const updates = JSON.parse(e.data);
  console.log("Updated data: ", updates);
});
```

### React clients

This event-listener setup integrates cleanly with React-based frontends using [`useEffect`](https://react.dev/reference/react/useEffect) and [`useState`](https://react.dev/reference/react/useState).
A React component powered by a Skip reactive service can establish the event stream and register listener callbacks as follows, calling the React `set` state functions within the callbacks with the data received from the reactive backend service.

```typescript
const [foo, setFoo] = useState(...);
useEffect(() => {
  const stream = new EventSource("http://reactive.service.hostname/my_resource/foo");
  stream.addEventListener("init", (e: MessageEvent<string>) => {
    const initial_data = JSON.parse(e.data);
    const initialFoo = ...; // create an initial "foo" using `initial_data`
    setFoo(initialFoo);
  });
  stream.addEventListener("update", (e: MessageEvent<string>) => {
    const updates = JSON.parse(e.data);
    const updatedFoo = ...; // update "foo" using `updates`
    setFoo(updatedfoo);
  });
  return () => {
    stream.close();
  };
}, [])
```

## Synchronous HTTP interface

Skip reactive services also support synchronous (i.e. non-reactive) reads of resources, either in their entirety or at a specific key.
Note that this requires instantiation of the resource, just the same as reactive streaming would.
As such, there is little advantage to synchronous reads in systems built using reactive services.
They are useful, however, for debugging the state of reactive systems and for maintaining compatibility with legacy systems and non-reactive clients.

To make a synchronous read, call either [`getAll`](api/helpers/classes/SkipServiceBroker#getall) or [`getArray`](api/helpers/classes/SkipServiceBroker#getarray) on the reactive service handle (i.e. `SkipServiceBroker`) in your web service to query the corresponding routes on the reactive service; an example using `getArray` is given in the example Express web service [below](client.md#example-web-service-configuration).
Then, from your client, issue HTTP `GET` requests to e.g. `http://reactive.service.hostname/my_resource/foo/key1` to make a synchronous read of data in the `foo` resource instance associated with key `key1`.

Synchronous writes and other reactive service operations can be exposed analogously, by calling [`update`](api/helpers/classes/SkipServiceBroker#update) on the reactive service from your web backend.

Note that, though `SkipServiceBroker` offers a convenient programmatic interface to the underlying reactive service operations, it is a thin wrapper around the HTTP interface documented [here](api/server/functions/runService).
If your web backend is written in a different language, then you can construct and send equivalent requests, accessing the `/v1/snapshot` route for synchronous resource reads and `/v1/resources/:collection` for synchronous input collection writes.

## Example web service configuration

Skip reactive services instantiate resources on request, generating a UUID for each distinct query and serving the resulting stream of updates over HTTP.
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

// On receiving a GET request for a reactive resource instance,
//  1. Parse out any params from the request
//  2. Request a stream identifier with those parameters from the reactive service
//  3. Redirect the client to the corresponding stream address
app.get("/my_resource/:id", (req, res) => {
  const params = { id: req.params.id, foo: req.params.bar, ... };
  reactive_service
    .getStreamUUID("my_resource", params)
    .then((uuid) => {
      res.redirect(301, `http://${reactive_host}:${streaming_port}/v1/streams/${uuid}`);
    })
});

// Synchronous read of a specific key in a resource instance
app.get("/my_resource/:id/:key", (req, res) => {
  const params = { id: req.params.id, foo: req.params.bar, ... };
  reactive_service
    .getArray("my_resource", params, req.params.key)
    .then((data) => {
      res.status(200).json(data);
    });
});
```
