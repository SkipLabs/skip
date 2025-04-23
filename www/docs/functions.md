# Writing functions

The Skip reactive computation runtime maintains a directed graph, with _vertices_ containing application data and _edges_ describing the computations that produce and manipulate that data.
This graph is used to automatically invalidate and re-evaluate computations when their input dependencies change -- but, it requires your application logic to be written in a form that supports this tracking of dependencies and re-evaluation!

This section describes the invariants your code must satisfy, gives some examples, and explains the guardrails that the Skip runtime puts in place to prevent common pitfalls.

## Overview

Skip mapper functions must be _side-effect-free_ and _deterministic_ in order to reliably and intuitively run in the Skip runtime environment, which will reevaluate them (when their inputs change) and reuse their results (when their inputs are _un_changed).

Out-of-band dependencies on imperative mutable state outside of the Skip heap can lead to stale results when that state changes.
Similarly, if a reactive computation mutates some external data, that mutation can happen repeatedly when inputs to the computation change, potentially causing bugs if the mutation is not idempotent.

Non-determinism can produce unexpected behavior in a reactive environment, since changing outputs will propagate through the computation graph, potentially incurring significant reevaluation costs.
The main invariant that the Skip runtime guarantees is _from-scratch consistency_ (i.e. reactive outputs are precisely the same as if the full computation were reexecuted from scratch, without any caching or reuse) which is weakened by non-determinisism.
Although non-determinism is not necessarily a bug in the strictest sense, it can make reactive systems difficult to reason about and should be used only with careful consideration.

## Examples

Mappers must implement the Skip `Mapper` interface and define a `mapEntry` function which takes a key and corresponding values from an input collection and produces some key/value pairs defining an output collection.

All keys and values must be JSON-encodable (i.e. extend `Json`), but the input collection's key/value types `K1`/`V1` do not need to coincide with the output collection's key/value types `K2`/`V2`.

```typescript
interface Mapper<
  K1 extends Json,
  V1 extends Json,
  K2 extends Json,
  V2 extends Json,
> {
  mapEntry(key: K1, values: Values<V1>): Iterable<[K2, V2]>;
}
```

First, let us revisit the example `Mapper` from the [previous section](getting_started.md):
```typescript
// Mapper function to compute the active users of each group
class ActiveMembers implements Mapper<GroupID, Group, GroupID, UserID> {
  constructor(private users: EagerCollection<UserID, User>) {}

  mapEntry(gid: GroupID, group: Values<Group>): Iterable<[GroupID, UserID]> {
    return group
      .getUnique()
      .members.flatMap((uid) =>
        this.users.getUnique(uid).active ? [[gid, uid]] : [],
      );
  }
}
```
The type instantiation `Mapper<GroupID, Group, GroupID, UserID>` indicates that this `Mapper` will be applied over a collection with `GroupID` keys and `Group` values, and produce a collection with `GroupID` keys and `UserID` values.
Note that while this function is mapped over a `GroupID` to `Group` collection, it also has access to the `users` collection provided to the constructor, and can read from `users` while processing each entry.
The Skip Runtime tracks that the output collection depends on both the input collection as well as the `users` collection, and keeps the output collection up-to-date in reaction to changes to either dependency.

Extending that social media application with Users and Groups example, suppose we want to maintain an index providing the set of groups of which each user is a member.
First, we define a mapper function:

```typescript
// Mapper function to compute the groups each user belongs to
class GroupsPerUser implements Mapper<GroupID, Group, UserID, GroupID> {
  mapEntry(gid: GroupID, group: Values<Group>): Iterable<[UserID, GroupID]> {
    return group.getUnique().members.map((uid) => [uid, gid]);
  }
}
```

Then, given an eager collection `groups` of type `EagerCollection<GroupID, Group>`, we can create an eager collection of groups per user:

```typescript
const groupsPerUser: EagerCollection<UserID, GroupID> = groups.map(GroupsPerUser);
```

This general form of `Mapper` allows arbitrary manipulation of collections' key/value structure.
For example, note that the key types of the input and output collections of `GroupsPerUser` are different, as are the value types.

Simpler mappers can maintain input collections' key/value structure _one-to-one_ (mapping one input value to one output value for the same key); for example, to compute each user's number of friends, we can define a `Mapper`:

```typescript
// Mapper function to compute each user's number of friends
class NumFriendsPerUser implements Mapper<UserID, User, UserID, number> {
  mapEntry(uid: UserID, user: Values<User>): Iterable<[UserID, number]> {
    return [[uid, user.getUnique().friends.length]];
  }
}
```

It is also common to collapse multiple values for a single key down to some aggregate with a _many-to-one_ `Mapper`; for example, to compute the number of active users in each group:

```typescript
// Mapper function to compute a _count_ of active users per group
class NumActiveMembers implements Mapper<GroupID, UserID, GroupID, number> {
  mapEntry(gid: GroupID, uids: Values<UserID>): Iterable<[GroupID, number]> {
    return [[gid, uids.toArray().length]];
  }
}
```

By mapping `NumActiveMembers` over the eager collection of active group members, we can produce an eager collection `activeMembers.map(NumActiveMembers)` of type `EagerCollection<GroupID, number>` with counts of active users per group, maintained up-to-date as users' activity status and group memberships change.

Note that this particular mapper -- counting the number of values per key -- would be better implemented as a `Reducer`, which is in fact available as a generic utility `Count` in Skip with a fast native implementation; this example is provided just to demonstrate use of a collapsing `Mapper`.
