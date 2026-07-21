# Services and Resources

The Skip framework supports end-to-end reactive programming: computations are evaluated reactively within each service, and data is pushed eagerly from reactive services to their consumers.

We've already seen the _intra_-service abstractions -- collections, mappers, and the like -- that make up a reactive service's computation graph (see the [getting started](getting_started.md) and [writing functions](functions.md) pages).

This page describes the concepts and abstractions that make up the _inter_-service communication layer.

## Overview

A Skip [reactive service](api/core/interfaces/SkipService) describes a reactive computation from some set of inputs to some set of outputs.

A service's inputs are its *input collections* (data owned by the service that can be freely read/written/mapped over) and its *external services* (any dependencies on outside systems or APIs).

A service's outputs are its *resources*, which define the types of requests that the service can handle, either by accessing data from its shared computation graph or by dynamically extending it with further reactive computation as needed to handle the request.
In this way, we can think of resources as parameterized outputs; request parameters are used to instantiate the resource and produce a *resource instance* containing the requested data.

For a concrete example, take the "active friends" resource from the getting-started [example](getting_started.md#the-anatomy-of-a-skip-service) service:

```typescript
// Load initial data from a source-of-truth database (mocked for simplicity)
const initialData: InitialData<ServiceInputs> = {
  users: ... ,
  groups: ... ,
};

// Specify and run the reactive service
const service = {
  initialData,
  resources: { active_friends: ActiveFriends },
  createGraph(input: ServiceInputs): ResourceInputs {
    const users = input.users;
    const activeMembers = input.groups.map(ActiveMembers, users);
    return { users, activeMembers };
  },
};
await runService(service);
```

The service has two input collections `users` and `groups` (where here we have elided their population with initial data), no external dependencies (i.e. the service definition does not define the optional `externalServices` field), and one resource: `ActiveFriends`, defined as follows:

```typescript
class ActiveFriends implements Resource<ResourceInputs> {
  private readonly uid: UserID;

  constructor(params: Json) {
    if (typeof params != "number")
      throw new Error("Missing required number parameter 'uid'");
    this.uid = params;
  }

  instantiate(inputs: ResourceInputs): EagerCollection<GroupID, UserID> {
    const user = inputs.users.getUnique(this.uid);
    return inputs.activeMembers.map(FilterFriends, user);
  }
}
```

In this setup, the reactive service exposes some routes corresponding to the resource, each expecting an HTTP query parameter `uid`.
When a request is made, the `constructor` is invoked with the given parameters and then `instantiate` is called on the resulting object, extending the shared computation graph (which updates `inputs`) with additional reactive computation, getting the relevant `user` and filtering active users according to whether or not they are friends.
The eager collection returned by the `instantiate` function is the output served to the client for this request, reactively updating according to any changes to input data: users, groups, friend relationships, etc.

This _resource instance_ can be explicitly closed by the client, or it will be garbage collected by the Skip framework after a period of inactivity.

When a Skip service depends on the output of another Skip service, its "request" for a resource instance is made using the [`Context#useExternalResource`](api/core/interfaces/Context#useexternalresource) API.
After registering an external service `"myOtherService"` (as described [here](externals.md)) with some `"my_resource"`, your service can call `context.useExternalResource("myOtherService", "my_resource", params)` to access that resource with the given parameters, allowing reactive computation to propagate through multiple services.

## Resource HTTP API

Skip reactive services expose a REST API across two separate ports: a *streaming* port for public-facing data streaming, and a *control* port for stream creation/deletion and synchronous reads/writes.
This bifurcation makes it easier to redirect clients directly to streaming endpoints while avoiding exposing sensitive control routes publicly.

### Streaming API

The data streaming API (on port 8080 by default) consists of a single endpoint:

```
GET /v1/streams/:uuid
```

After instantiating a resource and receiving the corresponding UUID (via the control API), clients can query this endpoint to receive initial data and updates via server-sent events, as described [here](client.md).

### Control API

The control API (on port 8081 by default) surfaces resource instantiation/deletion operations and synchronous read/write operations.

Resource instantiation and deletion are controlled by two routes:

```
POST /v1/streams/:resource
DELETE /v1/streams/:uuid
```

The `POST` route instantiates the named resource parameterized by the JSON-encoded request body and returns a UUID identifying the resource, which can then be used in a query to the streaming API.
The `DELETE` route closes and tears down the resource instance identified by its `uuid` parameter, terminating any active streams.

Synchronous reads from reactive resources can either access the resource in its entirety or read the data for a single key, using routes:

```
POST /v1/snapshot/:resource
POST /v1/snapshot/:resource/lookup
```

The first route returns all of the entries in the named `resource`, using the parameters provided in the JSON-encoded request body.
It instantiates the resource if needed, then returns a JSON-encoded array of key/value entries, with each entry a tuple of the form `[key, [value1, value2, ...]]`.

The second route requires the request body to be a JSON-encoded value with a `key` field and a `params` field.
It instantiates the resource if needed, then returns a JSON-encoded array of all values associated to `key` in the resource.

Clients can update the input collections of a reactive service:

```
PATCH /v1/inputs/:collection
```

This route updates an input collection `collection` with the value(s) passed in its JSON-encoded request payload.
It updates multiple keys simultaneously with the data in the body of the request, which must be an array of `[K, V[]]` entries for the key/value types `K` and `V` of the input collection.

For example, with `string` keys and `number` values, a request body of `[["key1",[10,20]],["key2",[]],["key3",[50]]]` associates `key1` to the values `10` and `20`, deletes any values under `key2`, and associates `key3` to the value 50.

Finally, clients can check that the service is running normally:

```
GET /healthz
```

This route will return HTTP 200 if the service is healthy.
