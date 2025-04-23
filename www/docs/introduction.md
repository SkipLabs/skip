# Introduction

## Overview

*Skip* is an open-source framework that enables software developers to build and run reactive services and systems.

Skip services expose reactive *resources*: data and computation outputs which can be queried over HTTP by non-reactive clients or subscribed to by reactive clients to receive updates in real time.

Skip services are written in a declarative style, defining a reactive computation graph over some input data.
Under the hood, the Skip framework efficiently evaluates and updates reactive computations, delivering up-to-date and correct results without incurring heavy recomputation costs or requiring any bug-prone explicit handling of dependency tracking or change propagation.

## Core concepts

The main components of the *Skip Runtime*, the reactive computation engine at the core of the Skip system, are *collections* and *mappers*.

Collections and mappers together form a graph of data and computation dependencies that the engine can use to efficiently maintain reactive computations as inputs and data are updated.

*Collections* are the core data structure over which reactive computations operate, they are the *vertices* of the Skip reactive computation graph.
A collection consists of *elements*, each of which associates one or more *values* to a *key*.
Keys and values can be arbitrary JSON data.

Collections can either be *eager*, meaning they are always kept up-to-date, or *lazy*, meaning that values are only computed or updated in response to queries for a particular key.

Each *mapper* expresses a computation from elements of one collection to elements of another collection. Mappers form the *edges* of the Skip reactive computation graph, specifying transformations and compositions of data to produce intermediate results and outputs.

Crucially, mappers must be deterministic and side-effect free, so that the reactive runtime can re-execute them as needed to maintain results that are both up-to-date and guaranteed from-scratch consistent (that is, exactly the same as the result that would be computed if the equivalent non-reactive computation were executed from scratch on the current input).

