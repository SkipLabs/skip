import type {
  EagerCollection,
  InitialData,
  Mapper,
  NonEmptyIterator,
  Resource,
} from "@skipruntime/api";

import { runService } from "@skipruntime/server";
import { deepFreeze } from "skip-wasm";

type UserID = number;
type GroupID = number;
type User = { name: string; active?: boolean; friends: UserID[] };
type Group = { name: string; members: UserID[] };

// Load initial data from a source-of-truth database (mocked for simplicity)
const initialData: InitialData<ServiceInputs> = {
  users: [
    [1, [deepFreeze({ name: "Bob", active: true, friends: [2, 3] })]],
    [2, [deepFreeze({ name: "Alice", active: true, friends: [1, 3] })]],
    [3, [deepFreeze({ name: "Carol", active: false, friends: [1, 2] })]],
    [4, [deepFreeze({ name: "Eve", active: true, friends: [] })]],
  ],
  groups: [
    [1, [deepFreeze({ name: "Group1", members: [1, 2, 3, 4] })]],
    [2, [deepFreeze({ name: "Group2", members: [1, 3, 4] })]],
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
    const actives: Array<[GroupID, UserID]> = [];
    for (const uid of group.getUnique().members) {
      if (this.users.getUnique(uid).active) actives.push([gid, uid]);
    }
    return actives;
    // Logic should be as follows, but WasmHandle proxies don't support filter/map???
    //        return group
    //          .getUnique()
    //          .members.filter((uid) => this.users.getUnique(uid).active)
    //          .map((uid) => [gid, uid]);
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
      .reduce(
        (acc, uid) =>
          this.user.friends.includes(uid) ? [...acc, [gid, uid]] : acc,
        [] as Array<[GroupID, UserID]>,
      );
  }
}

class ActiveFriends implements Resource<ResourceInputs> {
  private uid: UserID;
  constructor(params: { [param: string]: string }) {
    if (!params["uid"]) throw new Error("Missing required parameter 'uid'");
    this.uid = parseInt(params["uid"]);
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
  8991,
);
function shutdown() {
  service.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
