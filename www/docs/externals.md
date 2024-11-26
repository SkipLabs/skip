# External data sources

## Overview

Skip is designed to carefully track the computation and data dependencies, so that your service's outputs can be efficiently updated if (and only if!) any inputs they depend on change.
However, when those inputs come from external systems or services it is crucial to ensure that your reactive service still produces up-to-date results.

Skip provides mechanisms to do so easily, whether those external systems are other reactive Skip services or non-reactive systems like databases or external APIs.

The core of these mechanisms is the [`ExternalService` type](todo: API docs link), which provides a generic interface which can be implemented to wrap arbitrary external systems for use in your Skip service.
Each Skip reactive service can specify any number of `ExternalService`s, which can then be brought into the reactive computation graph as an `EagerCollection` with [`Context#useExternalResource`](todo: API docs link).

Skip provides two `ExternalService` implementations -- one which polls external HTTP services, and one which subscribes to external Skip services.
If your use case falls outside of these defaults, you can define your own custom external service by providing another `ExternalService` implementation with whatever arbitrary behavior is required.

## External Skip Services

Skip reactive services are designed to interoperate simply and easily: services push their changes reactively from the bottom-up, eagerly propagating updates through a distributed system.

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
  service: "myOtherService",
  identifier: "my_resource",
  params: {foo: bar, ...}
});

// Use the same as any other reactive eager collection:
externalData.map(...);
externalData.getArray(...);
```

This simple setup underlies one of the main strengths of the Skip framework: by receiving data from dependencies, computing any local changes, and pushing updates to dependents, multiple Skip services combine to implement an end-to-end reactive system.
Encapsulating external reactive dependencies as eager collections, that complex system is defined with simple declarative logic over the "current" state without explicit management of updates/changes.

## Non-Skip Services

