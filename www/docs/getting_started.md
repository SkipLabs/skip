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

At its core, a Skip service is a reactive computation graph describing how to compute some output _resources_ from some input collections and/or external API inputs.

```typescript
// Load initial data from a source-of-truth database
const users: db.getUsers(...);
const groups: db.getGroups(...);

// Specify and run service
const service = await runService({
    initialData: {users, groups},
    resources: {activeUsers : ActiveUsersResource},
    createGraph(inputs: {
      users: EagerCollection<UserID, User>;
      groups: EagerCollection<GroupID, Group>;
    }): {actives : EagerCollection<GroupID, UserID>} {
      return { actives: groups.map(FilterActive, users) };
	}
  }
)

class FilterActive implements Mapper<GroupID, Group, GroupID, UserID> {
  constructor(private users: EagerCollection<UserID, User>) {}
  mapElement(gid: GroupID, group: Group): Iterable<[GroupID, UserID]> {
    return group.members
      .filter((uid) => users.getUnique(uid).active)
      .map((uid) => [gid, uid]);
  }
}

class ActiveUsersResource implements Resource {

  instantiate(collections: {
    users: EagerCollection<UserID, User>;
    groups: EagerCollection<GroupID, Group>;
	actives : EagerCollection<GroupID, UserID>;
  }): EagerCollection<GroupID, UserID> {
	
  }
}

class FilterByFriend implements Mapper<GroupID, UserID, GroupID, UserID> {
  constructor(private users: EagerCollection<UserID, User>) {}
  mapElement(gid: GroupID, uid: UserID): Iterable<[GroupID, UserID]> {
    const friends
  }
}

```
