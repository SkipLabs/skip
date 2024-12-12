# External data sources

## Overview

Skip is designed to carefully track the computation and data dependencies, so that your service's outputs can be efficiently updated if (and only if!) any inputs they depend on change.
However, when those inputs come from external systems or services it is crucial to ensure that your reactive service still produces up-to-date results.

Skip provides mechanisms to do so easily, whether those external systems are other reactive Skip services or non-reactive systems like databases or external APIs.

The core of these mechanisms is the [`ExternalService` type](api/api/interfaces/ExternalService), which provides a generic interface which can be implemented to wrap arbitrary external systems for use in your Skip service.
Each Skip reactive service can specify any number of `ExternalService`s, which can then be brought into the reactive computation graph as an `EagerCollection` with [`Context#useExternalResource`](api/api/interfaces/Context#useexternalresource).

Skip provides two `ExternalService` implementations -- one which polls external HTTP services, and one which subscribes to external Skip services.
If your use case falls outside of these defaults, you can define your own custom external service by providing another `ExternalService` implementation with the required behavior.

## External Skip Services

Skip reactive services are designed to interoperate simply and easily: services push their changes reactively from the bottom up, eagerly propagating updates through a distributed system.

To receive data from another Skip service, specify it in the `externalServices` field of your `SkipService`, for example as follows:

```typescript
const service = await runService(
  {
    initialData: ...
    resources: ...
    createGraph: ...
    externalServices: {
      myOtherService: SkipExternalService.direct({
        host: "my.other.service.net",
        streaming_port: 8080,
        control_port: 8081,
      }),
    },
  }
);
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

## Non-Skip Services

Of course, unless your application is built from the ground up using the Skip framework, it is likely that your application depends on some non-reactive external system: REST APIs, databases, external HTTP endpoints, and the like.
These systems operate on a pull-based request/response paradigm, so some work is required to adapt them to Skip's eager push-based paradigm.

### Polling

The simplest option is *polling*, sending periodic requests to pull data from external sources and feed it into the reactive system.
To specify a polled external dependency, specify it in your service definition, e.g. as follows

```typescript
const service = await runService(
  {
    initialData: ...
    resources: ...
    createGraph: ...
    externalServices: {
      myExternalService: new GenericExternalService({
        my_resource: new Polled(
          // HTTP endpoint
          "https://api.example.com/my_resource",
		  // Polling interval, in milliseconds
          5000,
		  // data processing into `Entry<K, V>[]` key/values structure
          (data: Result) => data.results.map((value, idx) => [idx, [value]]))
      }),
    },
  }
);
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

### Custom External Resources/Services

If more control is required or your external system does not fit this form, then the `ExternalService` and `ExternalResource` interfaces both support extensions to define arbitrary logic for `subscribe`/`unsubscribe`-ing from services and `open`/`close`-ing resource.

For example, your service can keep track of open resources and combine requests to the external service if it supports batched requests, reducing request load and potentially allowing more optimized execution in the non-reactive system.
Similarly, an external relational database may support some limited form of reactivity/listening, such as PostgreSQL's `pg_notify`; in that case, a custom Skip `ExternalService` can interpret those updates into a form suitable for use within the Skip framework.
