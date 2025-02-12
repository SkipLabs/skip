import {
  type EagerCollection,
  type InitialData,
  type Json,
  type Mapper,
  type Resource,
  type Values,
} from "@skipruntime/core";

import { runService } from "@skipruntime/server";

const platform: "wasm" | "native" =
  process.env["SKIP_PLATFORM"] == "native" ? "native" : "wasm";

type UserID = number;
type GroupID = number;
type User = { name: string; active?: boolean; friends: UserID[] };
type Group = { name: string; members: UserID[] };

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

// Mapper function to compute the groups each user belongs to
class GroupsPerUser implements Mapper<GroupID, Group, UserID, GroupID> {
  mapEntry(gid: GroupID, group: Values<Group>): Iterable<[UserID, GroupID]> {
    return group.getUnique().members.map((uid) => [uid, gid]);
  }
}

// Mapper function to compute each user's number of friends
class NumFriendsPerUser implements Mapper<UserID, User, UserID, number> {
  mapEntry(uid: UserID, user: Values<User>): Iterable<[UserID, number]> {
    return [[uid, user.getUnique().friends.length]];
  }
}

// Mapper function to compute a _count_ of active users per group
class NumActiveMembers implements Mapper<GroupID, UserID, GroupID, number> {
  mapEntry(gid: GroupID, uids: Values<UserID>): Iterable<[GroupID, number]> {
    return [[gid, uids.toArray().length]];
  }
}

// Mapper function to filter out those active users who are also friends with `user`
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

// Load initial data from a source-of-truth database (mocked for simplicity)
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

// Specify and run the reactive service
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

const server = await runService(service, {
  streaming_port: 8080,
  control_port: 8081,
  platform,
});
function shutdown() {
  server.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
