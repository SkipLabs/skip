---
title: New built-in resources for Skip services
description: How to make Postgres and Kafka-backed reactive services
slug: non-reactive-dependencies
date: 2025-04-14
authors: benno
image: /img/skip.png
---

The Skip framework is a system for building and running incremental backend services, simplifying the challenges of engineering complex reactive systems.

While Skip reactive services compose naturally with *each other*, they must also coexist with other backend systems with non-reactive semantics and APIs.

This blog post describes some recent enhancements we've made to the Skip framework to make it easy to bridge the reactive/non-reactive interface for popular systems like PostgreSQL and Kafka, and shows how you can build similar integrations with other systems and APIs.

<!--truncate-->

## Postgres

PostgreSQL is one of the most popular relational databases in use today, serving as a highly scalable and resilient source-of-truth for critical application data.

For incremental computation, it can be tricky to maintain an up-to-date view of an application's state over a relational data model.
Different data sources add and modify values in an interconnected relational data model: you can either re-query and re-build the world periodically, or build some ad-hoc logic to propagate deltas.

Using Skip's [Postgres adapter](https://skiplabs.io/docs/api/adapters/postgres/classes/PostgresExternalService), developers can define some computation over their Postgres state and use the Skip framework to watch for changes in the relevant tables and recompute only the minimal affected outputs.

To use the Postgres addapter, when defining your Skip service, specify one (or more) databases in the `externalServices` field:

```typescript
const service = {
  initialData: ...,
  resources: ...,
  createGraph: ...,
  externalServices: {
    postgres: new PostgresExternalService({ host, port, database, ... }),
    ...,
  },
}
```

Then, anywhere in that service, you can pull in a database table as a Skip collection by specifying a table name and a column to use as the key of the collection.
For example, given a PostgreSQL table `my_table` with schema

```sql
CREATE TABLE my_table (id SERIAL PRIMARY KEY, value TEXT);
```

we can use the table as a collection `myTable` in a Skip reactive service as follows.

```typescript
const myTable: EagerCollection<number, { id: number, value: string }> =
  context.useExternalResource({
    service: "postgres",
    identifier: "my_table",
    params: { key: { col: "id", type: "SERIAL" } },
  });
```

Under the hood, Skip will maintain this collection up-to-date by watching the database for changes to `my_table`; the collection `myTable` will update incrementally the same as any other Skip collection and can be used in reactive computations combining multiple tables or any other Skip collection.

Although the `key` column specified here is the primary key column `id` of the table, it need not be a primary key or even unique -- it can be convenient to use a foreign key or other column to group multiple rows per key in the resulting Skip collection.

A more-involved example of a reactive service with computations over several Postgres tables is available [here](https://github.com/SkipLabs/skip/tree/main/examples/hackernews).

## Kafka

Apache [Kafka](https://kafka.apache.org) is another backend component with widespread adoption for high-throughput messaging and event streaming, often used to power real-time features.

Integrating a Kafka cluster with a Skip service is a natural way to build reactive logic on top of streaming data.
As such, we provide an ExternalService [adapter](https://skiplabs.io/docs/api/adapters/kafka/classes/KafkaExternalService) which handles the plumbing for you and abstracts Kafka message streams as Skip collections.

First, specify connection information and configuration in the `externalServices` field of your service:

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

then, consume messages into a reactive collection with a `usExternalResource` call, e.g.

```typescript
const myKafkaTopic: EagerCollection<string, string> =
  context.useExternalResource({
    service: "kafka",
    identifier: "my-kafka-topic",
    params: {},
  });
```

By default, messages are interpreted as their string key and value, but a "`messageProcessor`" can be provided to parse message payloads into other types, manipulate key structure, or pull in "topic" identifiers or other message metadata.


## Other external APIs

Of course, there are many other technologies and systems and you may need to integrate those with Skip.
The simplest option for many non-reactive APIs is to periodically poll an HTTP endpoint; we provide a simple interface to specify a polled dependency on a non-reactive API:

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
```

This [`PolledExternalService`](https://skiplabs.io/docs/api/helpers/classes/PolledExternalService) specifies a single endpoint polled every 5 seconds, but in general can include any number of endpoints with different polling intervals and converter/parser functions.

Of course, polling necessarily introduces some latency in the reactive service: data can become stale between polls.
On the other hand, increasing the request frequency can place undue load on the target non-reactive API.
As such, care should be taken when setting up a polled dependency to choose a reasonable interval, and where possible polling should be avoided in favor of genuinely reactive updates.


## What's next?

These three adapters ([`PostgresExternalService`](https://skiplabs.io/docs/api/adapters/postgres/classes/PostgresExternalService), [`KafkaExternalService`](https://skiplabs.io/docs/api/adapters/kafka/classes/KafkaExternalService), and [`PolledExternalService`](https://skiplabs.io/docs/api/helpers/classes/PolledExternalService)) are provided to make it easy to integrate with common backend systems, but all three are built using only public APIs and can easily be extended or tweaked in user code.

If your application would benefit from additional adapters for other components and technologies, you can implement an [`ExternalService`](https://skiplabs.io/docs/api/core/interfaces/ExternalService) to wrap non-reactive systems as inputs to your Skip service.

We welcome and support open-source contributions and feature requests and are always happy to answer questions or help out on Discord.

