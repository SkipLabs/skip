---
sidebar_position: 1
---

# Skip Overview

*Skip* is an open-source framework that enables software developers to build and run reactive services and systems.

The main components of the *Skip Runtime*, the reactive computation engine at the core of the Skip system, are *collections* and *mappers*.
Collections and mappers together form a graph of data and computation dependencies that the engine can use to efficiently maintain reactive computations as inputs and data are updated.

*Collections* are the core data structure over which reactive computations operate, they are the *vertices* of the Skip reactive computation graph.
A collection consists of *elements*, each of which associates one or more *values* to a *key*.
Keys and values can be arbitrary JSON data.
Collections can either be *eager*, meaning they are always kept up-to-date, or *lazy*, meaning that values are only computed or updated in response to queries for a particular key.

*Mappers* are values that express a computation from elements of one collection to elements of another collection.
Mappers form the *edges* of the Skip reactive computation graph, specifying transformations and compositions of data to produce intermediate results and outputs.
Crucially, mappers must be deterministic and side-effect free, so that the reactive runtime can re-execute them as needed to maintain results that are both up-to-date and guaranteed from-scratch consistent (that is, exactly the same as the result that would be computed if the equivalent non-reactive computation were executed from scratch on the current input).

*Table*s are a special form of *collection* with the proper metadata and structure that allows them to be (a) serialized and replicated over the wire with access controls and writer/author information, and (b) queried and manipulated using SQL, evaluated reactively by the Skip runtime.
