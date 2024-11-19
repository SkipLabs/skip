# External data sources

## Overview

Skip is designed to carefully track the computation and data dependencies, so that your service's outputs can be efficiently updated if (and only if!) any inputs they depend on change.
However, when those inputs come from external systems or services it is crucial to ensure that your reactive service still produces up-to-date results.

Skip provides mechanisms to do so easily, whether those external systems are other reactive Skip services or non-reactive systems like databases or external APIs.

The core of these mechanisms is the [`ExternalService` type](todo: API docs link), which provides a generic interface which can be implemented to wrap arbitrary external systems for use in your Skip service.
Each Skip reactive service can specify any number of `ExternalService`s, which can then be brought into the reactive computation graph as an `EagerCollection` with [`Context#useExternalResource`](todo: API docs link).

Skip provides two `ExternalService` implementations -- one which polls external HTTP services, and one which subscribes to external Skip services.

### External Skip Services

### Non-Skip Services

### Streaming sources

TODO: set up an example with a streaming source!
