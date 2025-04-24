# Glossary

This page defines and briefly explains the terminology and main concepts of the Skip framework.

* _Skip_: An open-source framework that enables software developers to build and run reactive services and systems.
  *Skip* is an overarching term to refer to the full ecosystem of tools and components described here.

* _Skiplang_: The Skip programming language, used by _SkipLabs_ to implement the core logic and data structures underpinning the *Skip* system.

* _(Skip) Runtime_: A full-fledged reactive computation engine, implemented in Skiplang and made available via bindings in other languages.
The core components of the runtime are *collections* and *mappers*, which together form a graph of data and computation dependencies that the engine can use to efficiently maintain reactive computations as inputs and data are updated.

* _Service_: A single-host reactive service implemented using the Skip runtime.
A service provides reactive *resources* which can be accessed by clients or other reactive services, which specify parameters and are provided with reactively-updated data computed and maintained by the service.
A service consists of some *input collections*, metadata to access *external services* (other Skip services and/or non-Skip HTTP endpoints) and a computation graph defining how to produce outputs from its inputs.

* _Resource_: The output of a Skip service is one or more *resources*, which are updated and maintained reactively.
Requests against resources can include parameters, and the corresponding results -- a *resource instance* specific to that client and request parameters -- are computed/updated until the client disconnects or unsubscribes.
Non-reactive requests can also be made, allowing legacy clients to query reactive services' resources.

* _Collection_: The core data structure over which reactive computations operate, collections associate *keys* with one or more *values*, both of which can be arbitrary JSON data.
Collections can either be *eager*, meaning they are always kept up-to-date, or *lazy*, meaning that values are only computed and/or updated in response to queries for a particular key.

* _Mapper_: Mappers describe computations from keys/values in one collection to keys/values in another collection.
They form the _edges_ of the Skip reactive computation graph, specifying transformations and compositions of data to produce intermediate results and outputs.
Crucially, they must be deterministic and side-effect free, so that the reactive runtime can re-execute them as needed to maintain results that are both up-to-date and guaranteed from-scratch consistent
(i.e. exactly the same as the result that would be computed if the equivalent non-reactive computation were executed from scratch on the current input).

* _(Skip) Client_: A thin client for a Skip reactive service which does not itself use the Skip Runtime, but operates over data which is kept up-to-date by the service.
