---
title: Reactive Social Network Service with Skip
description: Build step by step a skip service
slug: reactive_social_network_service_poc
date: 2025-04-30
authors: hubyrod
---

Reactive programming often sounds complex—but it doesn't have to be. What if you could actually see how data responds to change, in real time, right from your terminal?

In this tutorial, we walk through building a small proof-of-concept social network backend using [Skip](https://www.skiplabs.io/) and TypeScript. It tracks users, groups, and their friendships—with automatic updates to "active friends" using Skip’s reactive computation graph.

You’ll learn how to:

- Set up a reactive Skip service
- Define users and groups as live-updating resources
- Connect it all to a REST API using Express
- Observe real-time updates as the data evolves

> "The simpler, the merrier" — this project keeps things minimal, focused, and easy to explore.

From Alice adding a new friend to live data reactions, this guide makes reactive systems tangible.

{/* truncate */}

### The Simplest, the Merrier

Ever heard the saying, "The simpler, the better"? Well, that especially holds true when it comes to learning—particularly in reactive programming. Think of it like what we expect from a social network: *reactivity* in response to change. Sure, a full-blown social network has more bells and whistles than a carnival, but here we're just tackling a small piece of it. This guide keeps things light and breezy, focusing on the essentials to show how to build a reactive system using **Skip**. It's a proof of concept.

By keeping things simple and working right in the terminal, we can easily follow how data flows and how changes propagate—without getting lost in complexity. So let's dive in and have some fun while we're at it!

We'll start by building a Node project with TypeScript—because types, you know. Then, we'll define our data types. Since this is a social network, we want to represent friends and determine if they're active in a given group. We'll define members with names and associated groups, and for each group, we'll track whether a given member is active. After that, we'll build the Skip service, and finally, we'll wrap things up with a server that uses this service. All this will we be wrapped up in an example where Alice makes a new friend.

You can follow along with [the full code on GitHub](https://github.com/SkipLabs/reactive_social_network_service_poc), structured with a commit for each step:

### Step 1: The TypeScript Project

The whole first step can be found [here on GitHub](https://github.com/SkipLabs/reactive_social_network_service_poc/commit/b424165666b45a9d17b969f2422941f748556c85).

This first project really is Basic TypeScript 101, but watch out for some details such as the configuration of `package.json` and `tsconfig.json`. These two files can be sneaky little configuration traps if you're not careful. They might seem straightforward, but trust me, they can trip you up when you least expect it. So, keep an eye out and make sure everything is set up just right.

Let's create a directory for this proof-of-concept:

```bash
mkdir reactive_social_network_service
cd reactive_social_network_service
```

And now the TypeScript project:

```bash
npm init -y
npm install --save-dev typescript @types/node
mkdir -p src
npx tsc --init \
    --target ES2022 \
    --module nodenext \
    --rootDir "./src" \
    --outDir "./dist" \
    --moduleResolution nodenext
```

Configuration of `package.json` to prepare the project for what's about to come:

```bash
npm pkg set type="module"
npm pkg set scripts.build="tsc"
npm pkg set scripts.start="node dist/index.js"
npm pkg set scripts.clean="rm -rf dist node_modules"
```

We are now ready to enter the Skip world!

### Step 2: The Skip Service

The whole first step can be found [here on GitHub](https://github.com/SkipLabs/reactive_social_network_service_poc/commit/a63289aaae2404e62d1d212d870be042ab47f3e5).

We are going to need SkipLabs packages:

```bash
npm add @skiplabs/skip
```

So you better understand where we are heading, here is what the source directory will eventually look like:

```bash
src
    activefriends.mts
    data.mts
    index.ts
    skipservice.mts
    types.mts
```

And we start with the necessary types. In a nutshell, Skip defines a resource as the output of a Skip service. A resource is updated and maintained reactively. A collection is the core data structure over which reactive computations operate. An `EagerCollection` is always kept up-to-date. `LazyCollection` exists as well for evaluation upon queries only, but we are not using them in this proof-of-concept.

Here the code for `src/types.mts`:

```typescript
import {
    type EagerCollection,
} from "@skipruntime/core";

type UserID = number;
type GroupID = number;
type User = { name: string; active?: boolean; friends: UserID[] };
type Group = { name: string; members: UserID[] };

type ServiceInputs = {
    users: EagerCollection<UserID, User>;
    groups: EagerCollection<GroupID, Group>;
};

type ResourceInputs = {
    users: EagerCollection<UserID, User>;
    activeMembers: EagerCollection<GroupID, UserID>;
};

export type {
    UserID,
    GroupID,
    User,
    Group,
    ServiceInputs,
    ResourceInputs,
};
```

Now some data to get started. Outside this proof-of-concept, this would come from your database.

Four users and two groups e.g. Carol is in both groups but inactive.

Here is the code for `src/data.mts`:

```typescript
import { InitialData } from "@skipruntime/core";
import { ServiceInputs } from "./types.mjs";

// Initial data for the social network service
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

export { initialData };
```

Let's talk about active friends! For that, we need to define a filter for that `active` boolean. We are going to use a mapper. In Skip, a mapper describes a computation from keys/values in one collection to keys/values in another collection. It forms the edges of the Skip reactive computation graph, specifying transformations and compositions of data to produce intermediate results and outputs.

We are defining two mappers and a resource: one mapper to retrieve active members out of a given group, one mapper to retrieve friends of a given user out of a given group, and a resource which will hold active friends for a given user.

Here is the code for `src/activefriends.mts`:

```typescript
import {
    type EagerCollection,
    type Json,
    type Mapper,
    type Resource,
    type Values,
} from "@skipruntime/core";

import { GroupID, Group, UserID, User, ResourceInputs } from "./types.mjs";

// Mapper functions for reactive data transformations
class ActiveMembers implements Mapper<GroupID, Group, GroupID, UserID> {
    constructor(private users: EagerCollection<UserID, User>) { }

    // Maps group members to active users only
    mapEntry(gid: GroupID, group: Values<Group>): Iterable<[GroupID, UserID]> {
        return group
            .getUnique()
            .members.flatMap((uid: UserID) =>
                this.users.getUnique(uid).active ? [[gid, uid]] : [],
            );
    }
}

// Filters group members to only include friends of a specific user
class FilterFriends implements Mapper<GroupID, UserID, GroupID, UserID> {
    constructor(private readonly user: User) { }

    mapEntry(gid: GroupID, uids: Values<UserID>): Iterable<[GroupID, UserID]> {
        return uids
            .toArray()
            .flatMap((uid: UserID) => (this.user.friends.includes(uid) ? [[gid, uid]] : []));
    }
}

// Resource that provides active friends for a given user
class ActiveFriends implements Resource<ResourceInputs> {
    private readonly uid: UserID;

    constructor(params: Json) {
        if (typeof params != "number")
            throw new Error("Missing required number parameter 'uid'");
        this.uid = params;
    }

    // Creates a collection of active friends for the specified user
    instantiate(inputs: ResourceInputs): EagerCollection<GroupID, UserID> {
        const user = inputs.users.getUnique(this.uid);
        return inputs.activeMembers.map(FilterFriends, user);
    }
}

export { ActiveMembers, ActiveFriends };
```

And now the Skip service itself. It encompasses a server and a broker.

Here is the code for `src/skipservice.mts`:

```typescript
import { runService } from "@skipruntime/server";
import { SkipServiceBroker } from "@skipruntime/helpers";

import { ResourceInputs, ServiceInputs } from "./types.mjs";
import { initialData } from "./data.mjs";
import { ActiveFriends, ActiveMembers } from "./activefriends.mjs";

// Service configuration and reactive graph definition
const service = {
    initialData,
    resources: { active_friends: ActiveFriends },
    // Creates the reactive data flow graph
    createGraph(input: ServiceInputs): ResourceInputs {
        const users = input.users;
        const activeMembers = input.groups.map(ActiveMembers, users);
        return { users, activeMembers };
    },
};

// Start the reactive service with specified ports
const server = await runService(service, {
    streaming_port: 8080,
    control_port: 8081,
});

// Initialize the service broker for client communication
const serviceBroker = new SkipServiceBroker({
    host: "localhost",
    control_port: 8081,
    streaming_port: 8080,
});

export { server, serviceBroker };
```

### Step 3: The Server

The whole first step can be found [here on GitHub](https://github.com/SkipLabs/reactive_social_network_service_poc/commit/5fb3308540468243eeb10972d2ace887d5d3678b).

To use the Skip service, we are creating an [Express](https://expressjs.com/) server:

```bash
npm install express
npm install --save-dev @types/express
```

This server will expose an API to monitor active friends, and modify users and groups.

Here is the code for `src/index.ts`:

```typescript
import express, { Request, Response } from "express";
import { server, serviceBroker } from "./skipservice.mjs";

// Initialize Express app
const app = express();
app.use(express.json());

// Store a reference to the Express server
const expressServer = app.listen(8082, () => {
    console.log(`Groups REST wrapper listening at port 8082`);
});

// Utility function to handle errors
const handleError = (res: Response, error: unknown) => {
    console.error("Error: ", error);
    res.status(500).json(error);
};

// Route handlers
const getActiveFriends = async (req: Request, res: Response) => {
    try {
        const uuid = await serviceBroker.getStreamUUID("active_friends", Number(req.params.uid));
        res.redirect(301, `http://localhost:8080/v1/streams/${uuid}`);
    } catch (error) {
        handleError(res, error);
    }
};

const updateEntity = async (entity: string, idParam: string, req: Request, res: Response) => {
    try {
        const id = Number(req.params[idParam]);
        await serviceBroker.update(entity, [[id, [req.body]]]);
        res.status(200).json({});
    } catch (error) {
        handleError(res, error);
    }
};

// Define routes
app.get("/active_friends/:uid", getActiveFriends);
app.put("/users/:uid", (req: Request, res: Response) => updateEntity("users", "uid", req, res));
app.put("/groups/:gid", (req: Request, res: Response) => updateEntity("groups", "gid", req, res));

// Graceful shutdown handler for:
// - SIGINT: Ctrl+C in terminal
// - SIGTERM: System termination requests (kill command, container orchestration, etc.)
["SIGTERM", "SIGINT"].forEach((sig) => process.on(sig, async () => {
    await server.close();
    expressServer.close(() => {
        console.log("\nServers shut down.");
    });
}));
```

Let's install, build and start it!

```bash
npm install
npm run build
npm run start
```

Starting the server will display something like:

```bash
> reactive_social_network_service@1.0.0 start
> node dist/index.js

Skip control service listening on port 8081
Skip streaming service listening on port 8080
Groups REST wrapper listening at port 8082
```

The Express server listens to the steaming service for updates, and it is now time see it in action!

### Step 4: Let's See It Work

We are going to use three terminals: one is already running the server and the service, one to monitor changes on part 8082, and one to push modifications to port 8081.

While the service is running, in a fresh terminal, we are going to listen for changes on Alice's friends (index `1`):

```bash
curl -LN http://localhost:8082/active_friends/1 # Alice's active friends
```

The previous command will continue listening after displaying the following, hence you won't get any prompt back.

```bash
event: init
id: <SOME_HASH>
data: [[1002,[0]]]
```

Leave it like that and open the third and last terminal in which we are going to add and remove values to the initial data: the list of Alice friends is about to evolve:

```bash
curl http://localhost:8081/v1/inputs/users \
    -X PATCH \
    --json '[[1, [
    {
        "name": "Alice",
        "active": true,
        "friends": [0, 2, 3]
        }
    ]]]'
```

What do you see in the second terminal? The data is being reactively updated. Go ahead and try other modifications e.g. Bob turns inactive, Alice removes Carol from her group of friends.

### Wrapping Up

Reactive programming doesn't have to be intimidating. With Skip, we've seen how simple it is to wire up reactivity—from raw data all the way to live updates in an API. The idea is simple: when something changes, everything that depends on it updates automatically. And that's exactly what we built.

Of course, this is just the beginning. You now have a foundation for reactive services, and from here, the possibilities are wide open. Want to plug it into a real-time dashboard? Hook it into a game? Build collaborative tools?

### What's next?

For the next skip article, what should I tackle first? You tell me!

- Listening to live changes from a PostgreSQL database?
- Scaling your Skip service horizontally?
- Integrating with frontend frameworks like React?
- Managing authorization and privacy per user?
- What else would be useful to your projects?

We've exposed reactive programming in the nude, 'scuse my french. The reactive world can be vast and complex but SKIP will be your guide and now you've got a solid start.
