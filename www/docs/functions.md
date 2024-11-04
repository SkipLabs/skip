# Writing functions

The Skip reactive computation runtime maintains a directed graph, with _vertices_ containing application data and _edges_ describing the computations that produce and manipulate that data.
This graph is used to automatically invalidate and re-evaluate computations when their input dependencies change -- but, it requires your application logic to be written in a form that supports this tracking of dependencies and re-evaluation!

This section describes the invariants your code must satisfy, gives some examples, and explains the guardrails that the Skip runtime puts in place to prevent common pitfalls.

## Overview

Skip mapper functions must be _side-effect-free_ and _deterministic_ in order to reliably and intuitively run in the Skip runtime environment, which will reevaluate them (when their inputs change) and reuse their results (when their outputs are _un_changed).

Out-of-band dependencies on imperative mutable state outside of the Skip heap can lead to stale results when that state changes.
Similarly, if a reactive computation mutates some external data, that mutation can happen repeatedly when inputs to the computation change, potentially causing bugs if the mutation is not idempotent.

Non-determinism can produce unexpected behavior in a reactive environment, since changing outputs will propagate through the computation graph, potentially incurring significant reevaluation costs.
The main invariant that the Skip runtime guarantees is _from-scratch consistency_ (i.e. reactive outputs are precisely the same as if the full computation were reexecuted from scratch, without any caching or reuse) which is weakened by non-determinisism.
Although non-determinism is not necessarily a bug in the strictest sense, it can make reactive systems difficult to reason about and should be used only with careful consideration.

## Examples

Mappers must implement the Skip `Mapper` interface and define a `mapElement` function which takes a key and corresponding values from an input collection and produces some key/value pairs defining an output collection.

All keys and values must be JSON-encodable (i.e. extend `TJSON`), but the input collection's key/value types `K1`/`V1` do not need to coincide with the output collection's key/value types `K2`/`V2`.

```typescript
interface Mapper<
  K1 extends TJSON,
  V1 extends TJSON,
  K2 extends TJSON,
  V2 extends TJSON,
> {
  mapElement(key: K1, values: NonEmptyIterator<V1>): Iterable<[K2, V2]>;
}
```

For example, in a social media application with Users and Groups, we might want to maintain the set of active users for each group.
First, we define a mapping function:

```typescript
class ActiveUsersByGroup implements Mapper<UserID, User, GroupID, UserID> {
  mapElement(
    uid: UserID,
    users: NonEmptyIterator<User>,
  ): Iterable<[GroupID, UserID]> {
    const user = users.uniqueValue();
    if (user.isActive) return user.groups.map((gid) => [gid, uid]);
    else return [];
  }
}
```

Then, given an eager collection `users` of type `EagerCollection<UserID, User>`, we can create an eager collection of active group members:

```typescript
const activeGroupMembers : EagerCollection<GroupID, UserID> = users.map(ActiveUsersByGroup);
```

This general form of `Mapper` allows arbitrary manipulation of collections' key/value structure, but is often unnecessary and clunky for simple maps, especially those that preserve the key structure of their input and just manipulate the values.

For example, to maintain a _count_ of active users per group, we can define a `ManyToOneMapper`:

```typescript
class CountUsers extends ManyToOneMapper<GroupID, UserID, number> {
  mapValues(values: NonEmptyIterator<UserID>): number {
    return values.toArray().length;
  }
}
```

Then, map over the eager collection of group members to produce an eager collection `activeGroupMembers.map(CountUsers)` of type `EagerCollection<GroupID, number>` which maintains up-to-date counts of active users per group, as users' activity status and group memberships change.
Note that this mapper -- counting the number of values per key -- is available as a generic utility `CountMapper` in Skip; this example is provided just to demonstrate a use of `ManyToOneMapper`.


The simplest form of mapper maintains input collections' key/value structure one-to-one.
For example, to compute the number of groups each user belongs to, we can define a `OneToOneMapper`:

```typescript
class GroupsPerUser extends OneToOneMapper<UserID, User, number> {
  mapValue(user: User) : number {
    return user.groups.length
  }
}
```
