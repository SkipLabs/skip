import {
  type EagerCollection,
  type InitialData,
  type Json,
  type Resource,
  OneToManyMapper,
} from "@skipruntime/core";

import { runService } from "@skipruntime/server";

type UserID = number;
type GroupID = number;
type User = { name: string; active?: boolean; friends: UserID[] };
type Group = { name: string; members: UserID[] };

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
class ActiveUsers extends OneToManyMapper<GroupID, Group, UserID> {
  constructor(private users: EagerCollection<UserID, User>) {
    super();
  }

  mapValue(group: Group): UserID[] {
    return group.members.filter((uid) => this.users.getUnique(uid).active);
  }
}

// Mapper function to filter out those active users who are also friends with `user`
class FilterFriends extends OneToManyMapper<GroupID, UserID, UserID> {
  constructor(private readonly user: User) {
    super();
  }

  mapValue(uid: UserID): UserID[] {
    return this.user.friends.includes(uid) ? [uid] : [];
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
    return inputs.actives.map(FilterFriends, user);
  }
}

const service = {
  initialData,
  resources: { active_friends: ActiveFriends },
  createGraph(input: ServiceInputs): ResourceInputs {
    const actives = input.groups.map(ActiveUsers, input.users);
    return { users: input.users, actives };
  },
};

// Specify and run the reactive service
const server = await runService(service, {
  streaming_port: 8080,
  control_port: 8081,
});
function shutdown() {
  server.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
