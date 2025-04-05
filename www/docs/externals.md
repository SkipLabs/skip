# External data sources

## Overview

Skip is designed to carefully track computation and data dependencies, so that your service's outputs can be efficiently updated if (and only if!) any inputs they depend on change.
However, when those inputs come from external systems or services it is crucial to ensure that your reactive service still produces up-to-date results.

Skip provides mechanisms to do so easily, whether those external systems are other reactive Skip services or non-reactive systems like databases or external APIs.

The core of these mechanisms is the [`ExternalService` type](api/core/interfaces/ExternalService), which provides a generic interface which can be implemented to wrap arbitrary external systems for use in your Skip service.
Each Skip reactive service can specify any number of `ExternalService`s, which can then be brought into the reactive computation graph as an `EagerCollection` with [`Context#useExternalResource`](api/core/interfaces/Context#useexternalresource).

Skip provides several `ExternalService` implementations:

 * [`SkipExternalService`](api/helpers/classes/SkipExternalService), which is used to connect reactive Skip services together.
 * [`PostgresExternalService`](api/adapters/postgres/classes/PostgresExternalService), which allows to subscribe to reactive updates from a PostgreSQL database.
 * [`KafkaExternalService`](api/adapters/kafka/classes/KafkaExternalService), which allows to connect to and consume messages from a Kafka cluster.
 * [`PolledExternalService`](api/helpers/classes/PolledExternalService), which polls non-reactive HTTP endpoints with configurable parameter encoding, refresh interval, and the like.

If your use case falls outside of these defaults, you can define your own custom external service by providing another `ExternalService` implementation with the required behavior.

## External Skip services

Skip reactive services are designed to interoperate simply and easily: services push their changes reactively from the bottom up, eagerly propagating updates through a distributed system.

To receive data from another Skip service, specify it in the `externalServices` field of your `SkipService`, for example as follows:

```typescript
const service = {
  initialData: ...,
  resources: ...,
  createGraph: ...,
  externalServices: {
    myOtherService: SkipExternalService.direct({
      host: "my.other.service.net",
      streaming_port: 8080,
      control_port: 8081,
    }),
  },
};

await runService(service);
```

This instantiates a new service, with a dependency on a service named `myOtherService` running at the specified ports of `my.other.service.net`.
That dependency can then be referenced anywhere with access to the Skip context (e.g. in `createGraph`, mapper functions, or resource `instantiate` functions) as follows:

```typescript
// Pull in data from external resource:
const externalData : EagerCollection<K, V> = context.useExternalResource({
  service: "myOtherService", // References this service's `externalServices` field
  identifier: "my_resource", // References the other service's `resources` field
  params: {foo: bar, ...}  // Passed to other service's Resource constructor
});

// Use the same as any other reactive eager collection:
externalData.map(...);
externalData.getArray(...);
```

This simple setup underlies one of the main strengths of the Skip framework: by receiving data from dependencies, computing any local changes, and pushing updates to dependents, multiple Skip services combine to implement an end-to-end reactive system.
Encapsulating external reactive dependencies as eager collections, that complex system is defined with simple declarative logic over the "current" state without explicit management of updates/changes.

## Non-Skip services

Of course, unless your application is built from the ground up using the Skip framework, it is likely that your application depends on some non-reactive external system: REST APIs, databases, external HTTP endpoints, and the like.

These external services are provided in Skip framework packages for convenience but they can be customized, added to, or reimplemented as needed for a given use case; nothing beyond the public API is used in their implementations.

### PostgreSQL

One common use case for Skip is to reactively update and push results in response to updates in a relational database.
Skip makes this easy for PostgreSQL users, providing an adapter `PostgresExternalService` that can subscribe to updates from a Postgres database and expose them as an eager collection within your Skip reactive logic.

A complete example is available [here](https://github.com/SkipLabs/skip/tree/main/examples/hackernews/reactive_service); a basic usage is to specify a Skip service with a Postgres external service, i.e.

```typescript
const service = {
  initialData: ...,
  resources: ...,
  createGraph: ...,
  externalServices: {
    postgres: new PostgresExternalService({ host, port,  ... }),
    ...,
  },
}
```

and subscribe to a table (e.g. `create table t (id serial primary key, value text)`) as an EagerCollection, which can be mapped over or otherwise used in reactive logic.

```typescript
const t: EagerCollection<number, { id: number, value: string }> =
  context.useExternalResource({
    service: "postgres",
    identifier: "t",
    params: { key: { col: "id", type: "SERIAL" } },
  });
```

PostgreSQL rows are converted into JavaScript objects keyed by column names using the [`pg-types`](https://www.npmjs.com/package/pg-types) package, which can be customized according to its documentation if further control is needed over the JavaScript representation of Postgres data.

### Kafka

Many backend systems use distributed event streaming and messaging systems to handle real time data.
Skip can process Kafka message streams, allowing to reactively compute over incoming events, with Kafka "topics" treated as external resources.

An example can be seen [here](https://github.com/SkipLabs/skip/tree/main/examples/chatroom/reactive_service); a basic usage is to specify a Skip service with a Kafka external service, i.e.

```typescript
const service = {
  initialData: ...,
  resources: ...,
  createGraph: ...,
  externalServices: {
    kafka: new KafkaExternalService({ clientId, brokers, ... }),
    ...,
  },
}
```

and consume messages into a reactive collection as follows:

```typescript
const myKafkaTopic: EagerCollection<string, string> =
  context.useExternalResource({
    service: "kafka",
    identifier: "my-kafka-topic",
    params: {},
  });
```

By default, Kafka messages are imported into the Skip runtime as their string key and value, but a `KafkaExternalService` can be parameterized by a `messageProcessor` which allows to customize the interpretation of Kafka `{ key: string; value: string; topic: string }` messages as Skip runtime data, for example by performing type conversions or customizing key structure.

### Polling
Many existing systems operate on a pull-based request/response paradigm, so some work is required to adapt them to Skip's eager push-based paradigm.

The simplest option is *polling*, sending periodic requests to pull data from external sources and feed it into the reactive system.
To specify a polled external dependency, specify it in your service definition, e.g. as follows

```typescript
const service = {
  initialData: ...
  resources: ...
  createGraph: ...
  externalServices: {
    myExternalService: new PolledExternalService({
      my_resource: {
        // HTTP endpoint
        url: "https://api.example.com/my_resource",
        // Polling interval, in milliseconds
        interval: 5000,
        // data processing into `Entry<K, V>[]` key/values structure
        conv: (data: Json) => Array.from(data, (v, k) => [k, [v]])
      }
    }),
  },
};
await runService(service);
```

Although the underlying data source is non-reactive, this external service can be used identically to reactive external Skip services as in the previous section, e.g.

```typescript
// Pull in data from external resource:
const externalData : EagerCollection<K, V> = context.useExternalResource({
  service: "myExternalService",
  identifier: "my_resource",
  params: {foo: bar, ...}
});

// Use the same as any other reactive eager collection:
externalData.map(...);
externalData.getArray(...);
```

When the external resource is "used" in this fashion, Skip queries the HTTP endpoint with the given query `params` periodically, updating `externalData` with the results and allowing it to be used as if it were a reactive resource.
The frequency of those requests is an important consideration, depending on the latency requirements of the application as well as the load capacity of the external system.

### Custom external resources/services

If more control is required or your external system does not fit this form, then the `ExternalService` and `ExternalResource` interfaces both support extensions to define arbitrary logic for `subscribe`/`unsubscribe`-ing from services and `open`/`close`-ing resource.

For example, your service can keep track of open resources and combine requests to the external service if it supports batched requests, reducing request load and potentially allowing more optimized execution in the non-reactive system.
Similarly, an external relational database may support some limited form of reactivity/listening, such as PostgreSQL's `pg_notify`; in that case, a custom Skip `ExternalService` can interpret those updates into a form suitable for use within the Skip framework.
