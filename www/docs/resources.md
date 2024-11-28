# Services and Resources

The Skip framework supports end-to-end reactive programming: computations are evaluated reactively within each service, and data is pushed eagerly from reactive services to their consumers.

We've already seen the _intra_-service abstractions -- collections, mappers, and the like -- that make up a reactive service's computation graph (see the [getting started](getting_started.md) and [writing functions](functions.md) pages).

This page describes the concepts and abstractions that make up the _inter_-service communication layer.

## Overview

A Skip [reactive service](api/api/interfaces/SkipService) describes a reactive computation from some set of inputs to some set of outputs.

A service's inputs are its *input collections* (data owned by the service that can be freely read/written/mapped over) and its *external services* (any dependencies on outside systems or APIs).

A service's outputs are its *resource*, which define the types of requests that the service can handle, either by accessing data from its static computation graph or by dynamically extending it with further reactive computation as needed to handle the request.
In this way, we can think of resources as parameterized outputs; request parameters are used to instantiate the resource and produce a *resource instance* containing the requested data.

For a concrete example, take the "active friends" resource from the getting-started [example](getting_started.md#the-anatomy-of-a-skip-service) service:

```typescript
const service = await runService({
  initialData: { users, groups },
  resources: { active_friends: ActiveFriends },
  createGraph(input: ServiceInputs): ResourceInputs {
    const actives = input.groups.map(ActiveUsers, input.users);
    return { users: input.users, actives };
  },
});
```

The service has two input collections `"users"` and `"groups"` (populated here with some initial data), no external dependencies (i.e. the service definition does not define the optional `externalServices` field), and one resource: `ActiveFriends`, defined as follows:

```typescript
class ActiveFriends implements Resource<ResourceInputs> {
  private uid: UserID;

  constructor(params: { [param: string]: string }) {
    if (!params["uid"]) throw new Error("Missing required parameter 'uid'");
    this.uid = params["uid"];
  }

  instantiate(inputs: ResourceInputs): EagerCollection<GroupID, UserID> {
    const user = inputs.users.getUnique(this.uid);
    return inputs.actives.map(FilterFriends, user);
  }
}
```

In this setup, the reactive service exposes some routes corresponding to the resource, each expecting an HTTP query parameter `uid`.
When a request is made, the `constructor` is invoked with the given parameters and then `instantiate` called on the resulting object, extending the static computation graph (which updates `inputs`) with additional reactive computation, getting the relevant `user` and filtering active users according to whether or not they are friends.
The return value of the `instantiate` function makes up the output served to the client for this request, reactively updating according to any changes to input data: users, groups, friend relationships, etc.

## Resource HTTP API
