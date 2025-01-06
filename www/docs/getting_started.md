# Getting started

## Installation

Before you begin, we recommend installing the NPM packages for the Skip API, server, and helpers.

```npm install @skipruntime/api @skipruntime/server @skipruntime/helpers```

## Introduction

We have several resources available to help you learn the Skip framework, depending on your background and preferences.

This guide takes a "top-down" approach, showing you how to use our APIs in an idiomatic and practical way.  We recommend that most users start here.

Finally, if you'd like to just dive into the code, you can explore the [API docs](api/api), [examples](https://github.com/SkipLabs/skip/blob/main/skipruntime-ts/examples) of reactive services, or an [example configuration](https://github.com/SkipLabs/skip/blob/main/examples/hackernews) complete with reverse proxy and database.

## Tutorial

This guide will walk you through getting your first reactive service up and running using the Skip runtime.
It will also show how to write client code to read or subscribe to data from your reactive service.

We aim to make this as beginner friendly as possible, but assume an understanding of programming basics, including core JavaScript/Typescript syntax and semantics.

### Reactive Programming

Skip is a framework for building _reactive_ software which is responsive to changing inputs in real-time, efficient to execute, and intuitive to write and reason about.

From the outside, reactive services can be treated similarly to streaming sources: they push real-time updates to clients and other subscribers, supporting smooth real-time user experiences.
Unlike event-based streaming frameworks, though, Skip programs are written in a declarative style: instead of reasoning about updates directly, you write code that reasons about a "current" snapshot of state, and the Skip framework automatically processes changes and keeps everything in sync.

In order to do so, Skip tracks dependencies in a _computation graph_ in which input changes can be propagated through to relevant outputs *without* reevaluating any computation whose inputs haven't changed.

Skip's core abstractions are best understood in terms of this computation graph.

The primary data structure used in Skip is called a _collection_, and associates *keys* with one or more *values*.
Collection keys and values are both immutable data stored in the Skip framework's native heap; in Typescript, any JSON-serializable value can be used (that is:  primitives, arrays, objects, and nested combinations thereof, but not functions or classes).
Collections can be accessed by key or manipulated to create new collections.

These manipulations do _not_ mutate in-place but instead create a _new_ collection in the computation graph with a dependency edge from the input collection(s).
For example, `collection.map(Foo)` creates a _new_ collection with the results of applying `Foo` to the data in `collection`, which is then updated in real time whenever the contents of `collection` change.
(Along with `map`, Skip collections offer `mapReduce` and utilities like `merge`, `slice`, etc.)

Maps and other operations over Skip collections can be sequenced and combined to create complex computation graphs which are maintained up-to-date by reexecuting computation edges when inputs change.
Due to the structured nature of collections and maps, this can be done very efficiently -- always proportional to the size of the _change_, not the total size of the collection.

However, in order for the Skip framework to process updates correctly by reexecuting portions of its computation graph on changed inputs, it is crucial to capture all relevant dependencies.
For example, if a _mapper function_ (like `Foo` above) above reads and/or writes some global mutable state, then it may produce unexpected values when reexecuted by the framework.
In order to mitigate this, Skip programs written in Typescript use `Mapper` classes to define reactive computations which avoid the most problematic cases of untracked dependencies.
Nonetheless, while reading this guide and working with Skip, it is important to reason about (im)mutability and avoid side-effects in your code so that it can be reliably evaluated by the framework.

Some examples of Mappers are shown [below](getting_started#the-anatomy-of-a-skip-service) and more details are available [here](functions.md) or in the API [docs](api/api).

### The anatomy of a Skip service

Let's consider an example reactive service, powering a real-time feature in a social media application with the following simplified types.

```typescript
type UserID = ... ;
type GroupID = ... ;
type User = { name: string, active: boolean, friends: userID[], ... } ;
type Group = { name: string, members: UserID[], ... };
```

Suppose we want to display to users which of their currently-active friends are members of some group(s).

The logic is straightforward: filter the group's `members` by (1) intersection with the current user's `friends` and (2) those friends' `active` status.
However, it is far from trivial to maintain up-to-date information in real time as group membership lists, user friend lists, and user activity status are all changing.
Skip is designed to bridge this gap, letting you express the moment-in-time logic and leave updates and state management to the framework.

At its core, a Skip service is a reactive computation graph describing how to compute some output _resources_ from some input data and/or external API inputs.

A service is specified by an object passed to `runService`, which will then spin up a Skip runtime and server.
That object consists of `initialData` used to populate the service's input collections, some `resources` to make available over HTTP, and a function `createGraph` defining a static computation graph mapping the `ServiceInputs` to `ResourceInputs`.
This static computation graph will be maintained up-to-date at all times, and can be an arbitrarily complex computation graph or as simple as returning the input collections directly, depending on the service.

In this example, we pull initial user and group data from an external source-of-truth database, expose a single resource called `activeFriends`, and define a reactive computation of the active users in each group. 

```typescript
// Type alias for inputs to our service
type ServiceInputs = {
  users: EagerCollection<UserID, User>;
  groups: EagerCollection<GroupID, Group>;
};

// Type alias for inputs to the active friends resource
type ResourceInputs = {
  users: EagerCollection<UserID, User>;
  actives: EagerCollection<GroupID, UserID[]>;
};

// Mapper function to compute the active users of each group
class ActiveUsers extends OneToOneMapper<GroupID, Group, UserID[]> {
  constructor(private users: EagerCollection<UserID, User>) {
    super();
  }

  mapValue(group: Group): UserID[] {
    return group.members.filter((uid) => this.users.getUnique(uid).active);
  }
}

// Load initial data from a source-of-truth database (mocked for simplicity)
const [users, groups] = await Promise.all([
  db.getUsers( ... ),
  db.getGroups( ... ),
]);

// Specify and run the reactive service
const service = await runService({
  initialData: { users, groups },
  resources: { active_friends: ActiveFriends },
  createGraph(input: ServiceInputs): ResourceInputs {
    const actives = input.groups.map(ActiveUsers, input.users);
    return { users: input.users, actives };
  },
});
```

This example service operates over two _input collections_ (one for users and one for groups, as specified by `ServiceInputs`) and passes some `ResourceInputs` to its resources: a reactively-computed collection `actives` of the set of active users in each group, along with the `users` input collection.
This `actives` collection is the "output" of the static computation graph, produced by mapping over the input groups and filtering out users that have the `active` flag set; since this only has to be done once for the entire service, it can be maintained at all times.

Our service wants to expose a resource -- parameterized by a user ID -- which can be queried or subscribed to by clients to view that user's active friends in each group.
Maintaining this resource up-to-date for all users at all times would be infeasible at scale, so resources can make dynamic extensions to the reactive computation graph which are instantiated/dropped as needed to serve requests.

Resources are parameterized by some input HTTP `params` and use an `instantiate` function to set up any reactive computation, operating over the service's `ResourceInputs` to produce a single output collection.

```typescript
// Mapper function to filter out those active users who are also friends with `user`
class FilterFriends extends OneToOneMapper<GroupID, UserID[], UserID[]> {
  constructor(private readonly user: User) {
    super();
  }
  mapValue(uids: UserID[]): UserID[] {
    return uids.filter((uid) => this.user.friends.includes(uid));
  }
}

class ActiveFriends implements Resource<ResourceInputs> {
  private readonly uid: UserID;

  constructor(params: Json) {
    if (typeof params != "number")
      throw new Error("Missing required number parameter 'uid'");
    this.uid = params;
  }

  instantiate(inputs: ResourceInputs): EagerCollection<GroupID, UserID[]> {
    const user = inputs.users.getUnique(this.uid);
    return inputs.actives.map(FilterFriends, user);
  }
}
```

In this example, our `ActiveFriends` resource filters each groups' current active users to those users who are also currently friends with the given `uid`.

### See it in action

This guide aims to give the high-level ideas of how to write and reason about a Skip reactive service.
You can see and run the full example [here](https://github.com/SkipLabs/skip/blob/main/skipruntime-ts/examples/groups.ts), along with a corresponding [web application](https://github.com/SkipLabs/skip/blob/main/skipruntime-ts/examples/groups-server.ts) and [client](https://github.com/SkipLabs/skip/blob/main/skipruntime-ts/examples/groups-client.ts).

Run the service and web app as follows:

```
cd skipruntime-ts
make bunbuild
bun run examples/groups.ts &
bun run examples groups-server.ts &
```

With the reactive service running, you can run the client script with `bun run examples/groups-client.ts` and see changes in `active_friends` reflected in real time as users' friend lists, `active` status, and group memberships change.

Alternatively, use curl to listen for updates, e.g. with

```
curl -LN http://localhost:8082/active_friends/bob
```

and see the raw event stream as you issue updates to the input `users` and `groups` data from another shell.

### Next steps

This guide implements an example reactive service which can be queried or subscribed to by user's clients to see up-to-date listings of which of their active friends belong to each group, maintained up to date as input data changes without any explicit management of updates in the service's declarative logic.

We've shown the core reactive logic here without going into full detail on how to deploy and interact with a Skip service; see the [Deploying](deploying.md) guide for more details on how to wire reactivity into a generic web application, including how to handle user writes and feed those into input collections.

We've also elided the details of syncing data from external sources like databases or non-reactive APIs; see the [Externals](externals.md) guide for more details on how to keep your reactive service hydrated and in sync with updates from other components of your application.
