# Getting started

## Installation

Before you begin, we recommend installing the NPM packages for the Skip API, server, client, and helpers.

```npm install @skipruntime/api @skipruntime/server @skipruntime/client @skipruntime/helpers```

## Introduction

We have several resources available to help you learn the Skip framework, depending on your bcakground and preferences.

This guide takes a "top-down" approach, showing you how to use our latest APIs in an idiomatic and practical way.  We recommend that most users start here.

Alternatively, you can work from the "bottom-up" by reading our [Skip fundamentals](TODO:docusaurus link) tutorial, which explains the concepts and components of the Skip runtime from first principles.

Finally, if you'd like to just get your hands dirty and dive into the code, you can explore [examples](TODO: docusaurus link) of reactive services, [API docs](TODO: docusaurus link), or a before/after [example](TODO: docusaurus link) of retrofitting a legacy service with reactive features.

## Tutorial

This guide will walk you through getting your first reactive service up and running using the Skip runtime.
It will also show how to write client code to read or subscribe to data from your reactive service.

We aim to make this as beginner friendly as possible, but assume a basic understanding of imperative programming, including core JavaScript/Typescript syntax and semantics.

### Reactive Programming

Skip is a framework for building _reactive_ software which is responsive to changing inputs in real-time, efficient to execute, and intuitive to write and reason about.

From the outside, reactive services can be treated similarly to streaming sources: they push real-time updates to clients and other subscribers, supporting smooth real-time user experiences.
Unlike event-based streaming frameworks, though, Skip programs are written in a declarative style: instead of reasoning about updates directly, you write code that reasons about a "current" snapshot of state, and the Skip framework automatically processes changes and keeps everything in sync.

In order to do so, Skip tracks dependencies such that a change to an input can be propagated through that dependency graph without re-evaluating computations whose inputs haven't changed.
Therefore, while reading this guide and working with the Skip framework, it is crucial to reason about (im)mutability and side-effects in your code so that it can be reliably evaluated by the framework.

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
That object consists of `initialData` used to populate the service's input collections, some `resources` to make available over HTTPS, and a function `createGraph` defining a static computation graph mapping the `ServiceInputs` to `ResourceInputs`.
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
  actives: EagerCollection<GroupID, UserID>;
};

// Mapper function to compute the active users of each group
class ActiveUsers implements Mapper<GroupID, Group, GroupID, UserID> {
  constructor(private users: EagerCollection<UserID, User>) {}
  mapElement(gid: GroupID, group: Group): Iterable<[GroupID, UserID]> {
    return group.members
      .filter((uid) => users.getUnique(uid).active)
      .map((uid) => [gid, uid]);
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
  resources: { activeFriends: ActiveFriends },
  createGraph(input: ServiceInputs): ResourceInputs {
    const actives = groups.map(ActiveUsers, input.users);
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
class FilterFriends implements Mapper<GroupID, UserID, GroupID, UserID> {
  constructor(private user: User) {}
  mapElement(gid: GroupID, uid: UserID): Iterable<[GroupID, UserID]> {
    return user.friends.includes(uid) ? [[gid, uid]] : [];
  }
}

class ActiveFriends implements Resource<ResourceInputs> {
  constructor(private params: { uid: string }) {}
  instantiate(inputs: ResourceInputs): EagerCollection<GroupID, UserID> {
    const user = inputs.users.getUnique(UserID(this.params.uid));
    return inputs.actives.map(FilterFriends, user);
  }
}
```

In this example, our `ActiveFriends` resource filters each groups' current active users to those users who are also currently friends with the given `uid`.

### Next steps

This guide implements an example reactive service which can be queried or subscribed to by user's clients to see up-to-date listings of which of their active friends belong to each group, maintained up to date as input data changes without any explicit management of updates in the service's declarative logic.
We have showed the example without going into full detail on Skip data structures or programming primitives; see [todo: docusaurus link] for more details on the Skip programming model, collections, mapper functions, etc.
We've also elided the details of syncing data from external sources like databases or non-reactive APIs; see [todo: docusaurus link] for more details on how to keep your reactive service hydrated and in sync with updates from your app's write path.
