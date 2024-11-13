import type {
  EagerCollection,
  SkipService,
  Resource,
  Entry,
  Mapper,
  NonEmptyIterator,
} from "@skipruntime/api";

import { Max } from "@skipruntime/helpers";
import { runService } from "@skipruntime/server";
import {
  type ID,
  makeRequestCollection,
  IndexMapper,
} from "./skipsocial-utils.js";

import sqlite3 from "sqlite3";

/*
  This is the skip runtime service of the skipsocial example  
*/

/*****************************************************************************/
// Populate the database with made-up values (if it's not already there)
/*****************************************************************************/

async function initDB(): Promise<sqlite3.Database> {
  const db = new sqlite3.Database("./db.sqlite");
  const exec = (query: string): Promise<void> => {
    return new Promise((resolve, reject) => {
      db.exec(query, (err) => {
        if (err) reject(err);
        else resolve();
      });
    });
  };
  /*  const run = (
    query: string,
    params: Record<string, string>,
  ): Promise<void> => {
    return new Promise((resolve, reject) => {
      db.run(query, params, (err) => {
        if (err) reject(err);
        else resolve();
      });
    });
  };
*/
  // Create the table if it doesn't exist
  await exec(`CREATE TABLE IF NOT EXISTS data (
    id TEXT PRIMARY KEY,
    object JSON
    )`);

  /*
  await run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "123",
    $object: JSON.stringify({
      name: "daniel",
      country: "FR",
    }),
  });
  await run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "124",
    $object: JSON.stringify({
      name: "josh",
      country: "UK",
    }),
  });
  await run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "125",
    $object: JSON.stringify({
      name: "julien",
      country: "ES",
    }),
  });
*/
  return db;
}

/*****************************************************************************/
/* Error */
/*****************************************************************************/

/*
class Error {
  constructor(public msg: string) {}
}
*/

/*****************************************************************************/
/* Type use for timestamps */
/*****************************************************************************/

type Timestamp = number;

/*****************************************************************************/
/* Friends */
/*****************************************************************************/

type FriendRequest = {
  id: ID<FriendRequest>;
  action: "friend-request";
  to: ID<User>;
  from: ID<User>;
  timestamp: Timestamp;
};

class FriendRequestsResource implements Resource {
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<ID<User>, FriendRequest> {
    return tables.friendRequests;
  }
}

class FriendRequestsIndexResource implements Resource {
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<ID<[User, User]>, FriendRequest> {
    return tables.friendRequestsIndex;
  }
}

type Friend = {
  friendID: ID<Friend>;
};

class FriendsResource implements Resource {
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<ID<User>, Friend> {
    return tables.friends;
  }
}

class FriendMapper implements Mapper<ID<User>, string, ID<User>, Friend> {
  mapElement(
    friendID: ID<User>,
    requests: NonEmptyIterator<string>,
  ): Iterable<[ID<User>, Friend]> {
    return requests.map((x) => [friendID, { friendID: x }]);
  }
}

/*****************************************************************************/
/* Friends pairs, given a pair of users, returns true if they are friends. */
/*****************************************************************************/

class FriendIndexResource implements Resource {
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<ID<[User, User]>, Friend> {
    return tables.friendIndex;
  }
}

/*****************************************************************************/
// Messages and channels
/*****************************************************************************/

type Message = {
  id: ID<Message>;
  timestamp: number;
  from: ID<User>;
  to: ID<User>;
  content: string;
};

class MessageMapper implements Mapper<ID<Message>, Message, ID<User>, Message> {
  mapElement(
    _string: ID<Message>,
    messages: NonEmptyIterator<Message>,
  ): Iterable<[ID<User>, Message]> {
    let result: Array<[string, Message]> = [];
    for (const message of messages) {
      result.push([message.to, message]);
    }
    return result;
  }
}

class MessageFromToTimeStampMapper
implements Mapper<ID<Message>, Message, string, number> {
  mapElement(
    _string: ID<Message>,
    messages: NonEmptyIterator<Message>,
  ): Iterable<[string, number]> {
    let result: Array<[string, number]> = [];
    for (const message of messages) {
      result.push([message.from, message.timestamp]);
    }
    return result;
  }  
}

type UserIDObject = { kind: 'id', value: ID<User>}

class TimeStampUserMapper
implements Mapper<ID<User>, number, [number, ID<User>], UserIDObject> {
  mapElement(
    key: ID<User>,
    values: NonEmptyIterator<number>,
  ): Iterable<[[number, ID<User>], UserIDObject]> {
    return [[[values.first(), key], { kind: 'id', value: key }]];
  }
}

type LatestMessages = EagerCollection<[number, ID<User>], { kind: 'id', value: ID<User>}>;

export function latestMessage(
  messages: EagerCollection<ID<Message>, Message>
): LatestMessages {
  return messages
    .mapReduce(MessageFromToTimeStampMapper, new Max())
    .map(TimeStampUserMapper);
}

type MergedMessage =
   Message & {kind: 'object'}
| { kind: 'id', value: ID<User> }


class MessageTimeStampUserMapper
implements Mapper<ID<User>, Message, [number, ID<User>], MergedMessage> {
  mapElement(
    _key: ID<User>,
    messages: NonEmptyIterator<Message>,
  ): Iterable<[[number, ID<User>], MergedMessage]> {
    let result: Array<[[number, ID<User>], MergedMessage]> = [];
    for(const message of messages) {
      result.push([[message.timestamp, message.from], {...message, kind: 'object' }]);
    }
    return result;
  }
}

class MessageForUserMergeMapper
implements Mapper<[number, ID<User>], MergedMessage, ID<User>, Message> {
  constructor(private userID: ID<User>) {}
  mapElement(
    _key: [number, ID<User>],
    mergedMessages: NonEmptyIterator<MergedMessage>,
  ): Iterable<[ID<User>, Message]> {
    let object: null | Message = null;
    let hasID = false;
    for(const mergedMessage of mergedMessages) {
      if(mergedMessage.kind == 'id') {
        hasID = true;
        continue;
      }
      if(mergedMessage.kind == 'object') {
        object = mergedMessage;
      }
    }
    if(hasID && object !== null) {
      return [[this.userID, object]];
    }
    return [];
  }
}

class MessagesForUserResource implements Resource {
  constructor(private params: Record<string, string>) {}
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<ID<User>, Message> {
    const userID = this.params["userID"];
    if (typeof userID != "string") {
      throw new Error("Invalid userID: " + userID);
    }
    return tables
      .messagesByUser
      .slice([[userID, userID]])
      .map(MessageTimeStampUserMapper)
      .merge(tables.latestMessages)
      .map(MessageForUserMergeMapper, userID)
  }
}

type Group = {
  id: ID<Group>;
  timestamp: number;
  owner: ID<User>;
  name?: string;
  desc?: string;
};

class GroupsResource implements Resource {
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<ID<Group>, Group> {
    return tables.groups;
  }
}

type GroupMember = {
  id: ID<GroupMember>;
  timestamp: number;
  groupID: ID<Group>;
  userID: ID<User>;
};

class GroupMembersResource implements Resource {
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<ID<GroupMember>, GroupMember> {
    return tables.groupMembers;
  }
}

class GroupMemberIndex implements Resource {
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<ID<[User, User]>, GroupMember> {
    return tables.groupMemberIndex;
  }
}

/*****************************************************************************/
// The read path, we want to find a user
/*****************************************************************************/

type User = { name: string; country: string };

class UsersResource implements Resource {
  reactiveCompute(
    cs: { users: EagerCollection<string, User> },
  ): EagerCollection<string, User> {
    return cs.users;
  }
}

/*****************************************************************************/
// The read path for posts
/*****************************************************************************/

type Post = {
  id: string;
  content: string;
  authorID: string;
  timestamp: number;
};

type FullPost = Post & {
  comments: Comment[];
};

class PostsResource implements Resource {
  reactiveCompute(
    tables: Tables,
  ): EagerCollection<string, FullPost> {
    return tables.fullPosts;
  }
}

class PostMapper implements Mapper<string, Post, string, FullPost> {
  constructor(private commentsByPostID: EagerCollection<string, Comment>) {}
  mapElement(
    key: string,
    posts: NonEmptyIterator<Post>,
  ): Iterable<[string, FullPost]> {
    const post = posts.first();
    const comments = this.commentsByPostID.getArray(post.id);
    const fullPost = { ...post, comments };
    return [[key, fullPost]];
  }
}

/*****************************************************************************/
// The read path for comments
/*****************************************************************************/

export type Comment = {
  id: string;
  content: string;
  authorID: string;
  postID: string;
  timestamp: number;
};

class CommentsResource implements Resource {
  reactiveCompute(
    cs: { comments: EagerCollection<string, Comment> },
  ): EagerCollection<string, Comment> {
    return cs.comments;
  }
}

class CommentMapper implements Mapper<string, Comment, string, Comment> {
  mapElement(
    _key: string,
    values: NonEmptyIterator<Comment>,
  ): Iterable<[string, Comment]> {
    const comment = values.first();
    return [[comment.postID, comment]];
  }
}

/*****************************************************************************/
// Setting up the service
/*****************************************************************************/

type Inputs = {
  users: EagerCollection<ID<User>, User>;
  posts: EagerCollection<ID<Post>, Post>;
  comments: EagerCollection<ID<Comment>, Comment>;
  friendRequests: EagerCollection<ID<FriendRequest>, FriendRequest>;
  messages: EagerCollection<ID<User>, Message>;
  groups: EagerCollection<ID<Group>, Group>;
  groupMembers: EagerCollection<ID<GroupMember>, GroupMember>;
};

type Tables = Inputs & {
  messagesByUser: EagerCollection<ID<User>, Message>;
  fullPosts: EagerCollection<string, FullPost>;
  friends: EagerCollection<ID<User>, Friend>;
  friendIndex: EagerCollection<ID<[User, User]>, Friend>;
  groupMemberIndex: EagerCollection<ID<[User, User]>, GroupMember>;
  friendRequestsIndex: EagerCollection<ID<[User, User]>, FriendRequest>;
  latestMessages: LatestMessages;
};

class Service implements SkipService {
  initialData: {
    users: Entry<string, User>[];
    posts: Entry<string, Post>[];
    comments: Entry<string, Comment>[];
    friendRequests: Entry<string, Comment>[];
    messages: Entry<string, Message>[];
    groups: Entry<string, Group>[];
    groupMembers: Entry<string, GroupMember>[];
  };

  constructor(users: Entry<string, User>[]) {
    this.initialData = {
      users,
      posts: [],
      comments: [],
      friendRequests: [],
      messages: [],
      groups: [],
      groupMembers: [],
    };
  }

  resources = {
    users: UsersResource,
    messagesForUser: MessagesForUserResource,
    fullPosts: PostsResource,
    comments: CommentsResource,
    friends: FriendsResource,
    friendRequests: FriendRequestsResource,
    friendRequestsIndex: FriendRequestsIndexResource,
    friendIndex: FriendIndexResource,
    groups: GroupsResource,
    groupMembers: GroupMembersResource,
    groupMemberIndex: GroupMemberIndex,
  };

  reactiveCompute(inputCollections: Inputs): Tables {
    const messagesByUser = inputCollections.messages.map(MessageMapper);
    const commentsByPostID = inputCollections.comments.map(CommentMapper);
    const fullPosts = inputCollections.posts.map(PostMapper, commentsByPostID);
    const friendRequests = inputCollections.friendRequests;
    const friendRequestsIndex = friendRequests.map(IndexMapper<FriendRequest>, "from", "to");
    const friends = makeRequestCollection(friendRequests).map(FriendMapper);
    const friendIndex = friends.map(IndexMapper<Friend>, "$key", "friendID");
    const groupMemberIndex = inputCollections.groupMembers.map(
      IndexMapper<GroupMember>,
      "groupID",
      "userID",
    );
    const latestMessages = latestMessage(inputCollections.messages);
    const tables = {
      ...inputCollections,
      messagesByUser,
      fullPosts,
      friends,
      friendIndex,
      groupMemberIndex,
      friendRequestsIndex,
      latestMessages,
    };
    return tables;
  }
}

// Command that starts the service

const db = await initDB();
const data = await new Promise<Entry<string, User>[]>(function (
  resolve,
  reject,
) {
  db.all(
    "SELECT id, object FROM data",
    (err, data: { id: string; object: string }[]) => {
      if (err) {
        reject(err);
      } else {
        resolve(data.map((v) => [v.id, [JSON.parse(v.object)]]));
      }
    },
  );
});
db.close();

const closable = await runService(new Service(data), 8081);

function shutdown() {
  closable.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
