import type {
  EagerCollection,
  InitialData,
  Mapper,
  NonEmptyIterator,
  Resource,
} from "@skipruntime/api";

import { runService } from "@skipruntime/server";

type UserID = string;
type GroupID = string;
type User = { name: string; active?: boolean; friends: UserID[] };
type Group = { name: string; members: UserID[] };

// Load initial data from a source-of-truth database (mocked for simplicity)
const initialData: InitialData<ServiceInputs> = {
  users: [
    ["bob", [{ name: "Bob", active: true, friends: ["alice", "carol"] }]],
    ["alice", [{ name: "Alice", active: true, friends: ["bob", "carol"] }]],
    ["carol", [{ name: "Carol", active: false, friends: ["bob", "alice"] }]],
    ["eve", [{ name: "Eve", active: true, friends: [] }]],
  ],
  groups: [
    ["group1", [{ name: "Group 1", members: ["alice", "carol", "eve"] }]],
    ["group2", [{ name: "Group 2", members: ["bob", "carol"] }]],
  ],
};

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

  mapEntry(
    gid: GroupID,
    group: NonEmptyIterator<Group>,
  ): Iterable<[GroupID, UserID]> {
    return group
      .getUnique()
      .members.filter((uid) => this.users.getUnique(uid).active)
      .map((uid) => [gid, uid]);
  }
}

// Mapper function to filter out those active users who are also friends with `user`
class FilterFriends implements Mapper<GroupID, UserID, GroupID, UserID> {
  constructor(private user: User) {}

  mapEntry(
    gid: GroupID,
    uids: NonEmptyIterator<UserID>,
  ): Iterable<[GroupID, UserID]> {
    return uids
      .toArray()
      .reduce<
        [GroupID, UserID][]
      >((acc, uid) => (this.user.friends.includes(uid) ? [...acc, [gid, uid]] : acc), []);
  }
}

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

// Specify and run the reactive service
const service = await runService(
  {
    initialData,
    resources: { active_friends: ActiveFriends },
    createGraph(input: ServiceInputs): ResourceInputs {
      const actives = input.groups.map(ActiveUsers, input.users);
      return { users: input.users, actives };
    },
  },
  { streaming_port: 8080, control_port: 8081 },
);
function shutdown() {
  service.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
