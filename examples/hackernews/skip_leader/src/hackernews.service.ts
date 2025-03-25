import type {
  Context,
  EagerCollection,
  Values,
  Resource,
  SkipService,
} from "@skipruntime/core";

import { PostgresExternalService } from "@skip-adapter/postgres";

type Post = {
  author_id: number;
  title: string;
  url: string;
  body: string;
  date: number;
};

type User = {
  name: string;
  email: string;
};
const unknownUser: User = { name: "unknown author", email: "unknown email" };

type Upvote = {
  post_id: number;
  user_id: number;
};

type PostWithUpvoteIds = Post & { upvotes: number[]; author: User };

type Session = User & {
  user_id: number;
};

const postgres = new PostgresExternalService({
  host: "db",
  port: 5432,
  database: "postgres",
  user: "postgres",
  password: "change_me",
});

class UpvotesMapper {
  mapEntry(_key: number, values: Values<Upvote>): Iterable<[number, number]> {
    const upvote: Upvote = values.getUnique();
    return [[upvote.post_id, upvote.user_id]];
  }
}

class PostsMapper {
  constructor(
    private users: EagerCollection<number, User>,
    private upvotes: EagerCollection<number, number>,
  ) {}

  mapEntry(
    key: number,
    values: Values<Post>,
  ): Iterable<[[number, number], PostWithUpvoteIds]> {
    const post: Post = values.getUnique();
    const upvotes: number[] = this.upvotes.getArray(key);
    let author;
    try {
      author = this.users.getUnique(post.author_id);
    } catch {
      author = unknownUser;
    }
    return [[[-upvotes.length, key], { ...post, upvotes, author }]];
  }
}

type ResourceInputs = {
  postsWithUpvotes: EagerCollection<[number, number], PostWithUpvoteIds>;
  sessions: EagerCollection<string, Session>;
};

class SessionsResource implements Resource<ResourceInputs> {
  instantiate(collections: ResourceInputs): EagerCollection<string, Session> {
    return collections.sessions;
  }
}
class PostsWithUpvotesResource implements Resource<ResourceInputs> {
  instantiate(
    collections: ResourceInputs,
  ): EagerCollection<[number, number], PostWithUpvoteIds> {
    return collections.postsWithUpvotes;
  }
}

type ServiceInputs = {
  sessions: EagerCollection<string, Session>;
};

export const service: SkipService<ServiceInputs, ResourceInputs> = {
  initialData: {
    sessions: [],
  },
  resources: {
    postsWithUpvotes: PostsWithUpvotesResource,
    sessions: SessionsResource,
  },
  externalServices: { postgres },
  createGraph(inputs: ServiceInputs, context: Context): ResourceInputs {
    const serialIDKey = { key: { col: "id", type: "SERIAL" } };
    const posts = context.useExternalResource<number, Post>({
      service: "postgres",
      identifier: "posts",
      params: serialIDKey,
    });
    const users = context.useExternalResource<number, User>({
      service: "postgres",
      identifier: "users",
      params: serialIDKey,
    });
    const upvotes = context.useExternalResource<number, Upvote>({
      service: "postgres",
      identifier: "upvotes",
      params: serialIDKey,
    });
    return {
      postsWithUpvotes: posts.map(
        PostsMapper,
        users,
        upvotes.map(UpvotesMapper),
      ),
      sessions: inputs.sessions,
    };
  },
};
