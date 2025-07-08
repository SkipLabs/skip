# Getting started

## Installation

Before you begin, we recommend installing the NPM packages for the Skip Framework.

```npm install @skiplabs/skip```

The `@skiplabs/skip` package just depends on the separate component packages:
- `@skipruntime/core`: The Skip Runtime public API
- `@skipruntime/server`: Expose a reactive service through HTTP/SSE servers
- `@skipruntime/helpers`: Potentially useful functionality for working with Skip
- `@skipruntime/wasm`: The Wasm version of the Skip Runtime

and optionally:
- `@skipruntime/native`: The native version of the Skip Runtime
- `@skip-adapter/kafka`: Connector between Kafka and Skip
- `@skip-adapter/postgres`: Connector between PostgreSQL and Skip

Note that two versions of the runtime are available, Wasm `@skipruntime/wasm` and native `@skipruntime/native`.
The Wasm runtime works with both `node` and `bun`, but is limited to Wasm's 32-bit memory address space.
The native runtime does not have this limitation, but it is currently only available for Node and is a bit more involved to install.

The Wasm runtime is installed by default, but a package using Skip can choose to explicitly depend on only `@skipruntime/core`, `@skipruntime/server`, and `@skipruntime/native` to reduce weight.
The Wasm runtime can be installed separately with `npm install @skipruntime/wasm` and the native runtime by following the [instructions](https://github.com/SkipLabs/skip/blob/main/INSTALL.md).

## Introduction

We have several resources available to help you learn the Skip framework, depending on your background and preferences.

This guide takes a "top-down" approach, showing you how to use our APIs in an idiomatic and practical way.  We recommend that most users start here.

Finally, if you'd like to just dive into the code, you can explore the [API docs](api/core), [examples](https://github.com/SkipLabs/skip/blob/main/skipruntime-ts/examples) of reactive services, or an [example configuration](https://github.com/SkipLabs/skip/blob/main/examples/hackernews) complete with reverse proxy and database, including a version with a distributed leader-follower configuration.

## Tutorial

This guide will walk you through getting your first reactive service up and running using the Skip runtime.
It will also show how to write client code to read or subscribe to data from your reactive service.

We aim to make this as beginner friendly as possible, but assume an understanding of programming basics, including core JavaScript/TypeScript syntax and semantics.

### Reactive programming

Skip is a framework for building _reactive_ software which is responsive to changing inputs in real-time, efficient to execute, and intuitive to write and reason about.

From the outside, reactive services can be treated similarly to streaming sources: they push real-time updates to clients and other subscribers, supporting smooth real-time user experiences.
Unlike event-based streaming frameworks, though, Skip programs are written in a declarative style: instead of reasoning about updates directly, you write code that reasons about a "current" snapshot of state, and the Skip framework automatically processes changes and keeps everything in sync.

In order to do so, Skip tracks dependencies in a _computation graph_ in which input changes can be propagated through to relevant outputs *without* reevaluating any computation whose inputs haven't changed.

Skip's core abstractions are best understood in terms of this computation graph.

The primary data structure used in Skip is called a _collection_, and associates *keys* with one or more *values*.
Collection keys and values are both immutable data stored in the Skip framework's native heap; in TypeScript, any JSON-serializable value can be used (that is:  primitives, arrays, objects, and nested combinations thereof, but not functions or classes).
Collections can be accessed by key or manipulated to create new collections.

These manipulations do _not_ mutate in-place but instead create a _new_ collection in the computation graph with a dependency edge from the input collection(s).
For example, `collection.map(Foo)` creates a _new_ collection with the results of applying `Foo` to the data in `collection`, which is then updated in real time whenever the contents of `collection` change.
(Along with `map`, Skip collections offer `mapReduce` and utilities like `merge`, `slice`, etc.)

Maps and other operations over Skip collections can be sequenced and combined to create complex computation graphs which are maintained up-to-date by reexecuting computation edges when inputs change.
Due to the structured nature of collections and maps, this can be done very efficiently -- always proportional to the size of the _change_, not the total size of the collection.

However, in order for the Skip framework to process updates correctly by reexecuting portions of its computation graph on changed inputs, it is crucial to capture all relevant dependencies.
For example, if a _mapper function_ (like `Foo` above) reads and/or writes some global mutable state, then it may produce unexpected values when reexecuted by the framework.
In order to mitigate this, Skip programs written in TypeScript use `Mapper` classes to define reactive computations which avoid the most problematic cases of untracked dependencies.
Nonetheless, while reading this guide and working with Skip, it is important to reason about (im)mutability and avoid side-effects in your code so that it can be reliably evaluated by the framework.

Some examples of Mappers are shown [below](getting_started#the-anatomy-of-a-skip-service) and more details are available [here](functions.md) or in the API [docs](api/core).

### The anatomy of a Skip service

Let's consider an example reactive service, powering a real-time feature in a social media application with the following types.

```typescript
type UserID = number;
type GroupID = number;
type User = { name: string; active?: boolean; friends: UserID[] };
type Group = { name: string; members: UserID[] };
```

Suppose we want to display to users which of their currently-active friends are members of some group(s).

The logic is straightforward: filter the group's `members` by (1) intersection with the current user's `friends` and (2) those friends' `active` status.
However, it is far from trivial to maintain up-to-date information in real time as group membership lists, user friend lists, and user activity status are all changing.
Skip is designed to bridge this gap, letting you express the moment-in-time logic and leave updates and state management to the framework.

At its core, a Skip service is a reactive computation graph describing how to compute some output _resources_ from some input data and/or external API inputs.

A service is specified by an object passed to `runService`, which will then spin up a Skip runtime and server.
That object consists of `initialData` used to populate the service's input collections, some `resources` to make available over HTTP, and a function `createGraph` defining a shared computation graph mapping the `ServiceInputs` to `ResourceInputs`.
This shared computation graph will be maintained up-to-date at all times, and can be an arbitrarily complex computation graph or as simple as returning the input collections directly, depending on the service.

In this example, we pull initial user and group data from an external source-of-truth database, expose a single resource called `activeFriends`, and define a reactive computation of the active users in each group. 

```typescript
import {
    type EagerCollection,
    type InitialData,
    type Mapper,
    type Values,
} from "@skipruntime/core";

// Type alias for inputs to our service
type ServiceInputs = {
  users: EagerCollection<UserID, User>;
  groups: EagerCollection<GroupID, Group>;
};

// Type alias for inputs to the active friends resource
type ResourceInputs = {
  users: EagerCollection<UserID, User>;
  activeMembers: EagerCollection<GroupID, UserID>;
};

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

// Load initial data from a source-of-truth database (empty for now for simplicity)
const initialData: InitialData<ServiceInputs> = {
  users: [],
  groups: [],
};

// Specify and run the reactive service
const service = {
  initialData,
  resources: {},
  createGraph(input: ServiceInputs): ResourceInputs {
    const activeMembers = input.groups.map(ActiveMembers, input.users);
    return { users: input.users, activeMembers };
  },
};
await runService(service);
```

This example service operates over two _input collections_ (one for users and one for groups, as specified by `ServiceInputs`) and passes some `ResourceInputs` to its resources: a reactively-computed collection `activeMembers` of the set of active users in each group, along with the `users` input collection.
This `activeMembers` collection is the "output" of the shared computation graph, produced by mapping over the input groups and taking users that have the `active` flag set; since this only has to be done once for the entire service, it can be maintained at all times.

Our service wants to expose a resource -- parameterized by a user ID -- which can be queried or subscribed to by clients to view that user's active friends in each group.
Maintaining this resource up-to-date for all users at all times would be infeasible at scale, so resources can make dynamic extensions to the reactive computation graph which are instantiated/dropped as needed to serve requests.

Resources are parameterized by some input HTTP `params` and use an `instantiate` function to set up any reactive computation, operating over the service's `ResourceInputs` to produce a single output collection.

```typescript
import {
    type EagerCollection,
    type InitialData,
    type Mapper,
    type Values,
    // two more types to import here
    type Json,
    type Resource,
} from "@skipruntime/core";

// ... rest of your code so far

// Mapper function to find users that are active and also friends with `user`
class FilterFriends implements Mapper<GroupID, UserID, GroupID, UserID> {
  constructor(private readonly user: User) {}

  mapEntry(gid: GroupID, uids: Values<UserID>): Iterable<[GroupID, UserID]> {
    return uids
      .toArray()
      .flatMap((uid) => (this.user.friends.includes(uid) ? [[gid, uid]] : []));
  }
}

class ActiveFriends implements Resource<ResourceInputs> {
  private readonly uid: UserID;

  constructor(params: Json) {
    if (typeof params != "number")
      throw new Error("Missing required number parameter 'uid'");
    this.uid = params;
  }

  instantiate(inputs: ResourceInputs): EagerCollection<GroupID, UserID> {
    const user = inputs.users.getUnique(this.uid);
    return inputs.activeMembers.map(FilterFriends, user);
  }
}
```

In this example, our `ActiveFriends` resource filters each groups' current active users to those users who are also currently friends with the given `uid`.

Now, all we need to do is run the Skip service and broker. 
```typescript
import { runService } from "@skipruntime/server";

// Service definition
const service = {
    initialData,
    resources: { active_friends: ActiveFriends },
    createGraph(input: ServiceInputs): ResourceInputs {
        const users = input.users;
        const activeMembers = input.groups.map(ActiveMembers, users);
        const _groupsPerUser = input.groups.map(GroupsPerUser);
        const _numFriendsPerUser = users.map(NumFriendsPerUser);
        const _numActiveMembers = activeMembers.map(NumActiveMembers);
        return { users, activeMembers };
    },
};

// Run the reactive service
const server = await runService(service, {
    streaming_port: 8080,
    control_port: 8081,
});

// Initialize the SkipServiceBroker
const serviceBroker = new SkipServiceBroker({
    host: "localhost",
    control_port: 8081,
    streaming_port: 8080,
});
```

In your terminal, you should see the following: 

```console
Skip control service listening on port 8081
Skip streaming service listening on port 8080
```

For the sake of the example, you may want to change `initialData` for some mock data e.g.

```typescript
const initialData: InitialData<ServiceInputs> = {
    users: [
        [0, [{ name: "Bob", active: true, friends: [1, 2] }]],
        [1, [{ name: "Alice", active: true, friends: [0, 2] }]],
        [2, [{ name: "Carol", active: false, friends: [0, 1] }]],
        [3, [{ name: "Eve", active: true, friends: [] }]],
    ],
    groups: [
        [1001, [{ name: "Group 1", members: [1, 2, 3] }]],
        [1002, [{ name: "Group 2", members: [0, 2] }]],
    ],
};
```

### See it in action

This guide aims to give the high-level ideas of how to write and reason about a Skip reactive service.
You can see and run the full example [here](https://github.com/SkipLabs/skip/blob/main/skipruntime-ts/examples/groups.ts), along with a corresponding [web application](https://github.com/SkipLabs/skip/blob/main/skipruntime-ts/examples/groups-server.ts) and [client](https://github.com/SkipLabs/skip/blob/main/skipruntime-ts/examples/groups-client.ts).

Run the service and web app as follows:

```
cd skipruntime-ts/examples
npm run build
node dist/groups-server.js &
node dist/groups.js &
```

With the reactive service running, you can run the client script with `node dist/groups-client.js` and see changes in `active_friends` reflected in real time as users' friend lists, `active` status, and group memberships change.

Alternatively, use curl to listen for updates, e.g. with

```
curl -LN http://localhost:8082/active_friends/0
```

and see the raw event stream as you issue updates to the input `users` and `groups` data from another shell.

### Next steps

This guide implements an example reactive service which can be queried or subscribed to by users' clients to see up-to-date listings of which of their active friends belong to each group, maintained up to date as input data changes without any explicit management of updates in the service's declarative logic.

We've shown the core reactive logic here without going into full detail on how to deploy and interact with a Skip service; see the [Deploying](deploying.md) guide for more details on how to wire reactivity into a generic web application, including how to handle user writes and feed those into input collections.

We've also elided the details of syncing data from external sources like databases or non-reactive APIs; see the [Externals](externals.md) guide for more details on how to keep your reactive service hydrated and in sync with updates from other components of your application.
