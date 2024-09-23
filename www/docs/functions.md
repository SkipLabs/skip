# Writing functions

The Skip reactive computation runtime maintains a directed graph, with _vertices_
containing application data and _edges_ describing the computations that produce
and manipulate that data.  This graph is used to automatically invalidate and
re-evaluate computations when their input dependencies change -- but, it
requires your application logic to be written in a form that supports this
tracking of dependencies and re-evaluation!

This section describes the invariants your code must satisfy, gives some
examples, and explains the guardrails that the Skip runtime puts in place to
prevent common pitfalls.

## Overview

Skip mapper functions must be _side-effect-free_ and _deterministic_ in order to
reliably and intuitively run in the Skip runtime environment, which will
re-evaluate them (when their inputs change) and reuse their results (when their
outputs are _un_changed).

Out-of-band dependencies on imperative mutable state outside of the Skip heap
can lead to stale results when that state changes. Similarly, if a reactive
computation mutates some external data, that mutation can happen repeatedly when
inputs to the computation change, potentially causing bugs if the mutation is
not idempotent.

Non-determinism can produce unexpected behaviour in a reactive environment,
since changing outputs will propagate through the computation graph, potentially
incurring significant re-evaluation costs.  The main invariant that the Skip
runtime guarantees is _from-scratch consistency_ (i.e. reactive outputs are
precisely the same as if the full computation were re-executed from scratch,
without any caching or reuse) which is weakened by non-deterministism -- though
not necessarily a bug in the strictest sense, it can make reactive systems
difficult to reason about and should be used only with careful consideration.
