import type {
  Context,
  EagerCollection,
  Json,
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
};

type User = {
  name: string;
  email: string;
};

type Upvote = {
  post_id: number;
  user_id: number;
};

type Upvoted = Post & { upvotes: number; author: User };

type ResourceInputs = {
  postsWithUpvotes: EagerCollection<number, Upvoted>;
};

const postgres = new PostgresExternalService({
  host: "db",
  port: 5432,
  database: "postgres",
  user: "postgres",
  password: "change_me",
});

class UpvotesMapper {
  mapEntry(key: number, values: Values<Upvote>): Iterable<[number, number]> {
    const value = values.getUnique().post_id;
    return [[value, key]];
  }
}

class PostsMapper {
  constructor(
    private users: EagerCollection<number, User>,
    private upvotes: EagerCollection<number, number>,
  ) {}

  mapEntry(key: number, values: Values<Post>): Iterable<[number, Upvoted]> {
    const post: Post = values.getUnique();
    const upvotes = this.upvotes.getArray(key).length;
    const author = this.users.getUnique(post.author_id);
    // Projecting all posts on key 0 so that they can later be sorted.
    return [[0, { ...post, upvotes, author }]];
  }
}

class SortingMapper {
  mapEntry(key: number, values: Values<Upvoted>): Iterable<[number, Upvoted]> {
    const posts = values.toArray();
    // Sorting in descending order of upvotes.
    posts.sort((a, b) => b.upvotes - a.upvotes);
    return posts.map((p) => [key, p]);
  }
}

class PostsResource implements Resource<ResourceInputs> {
  private limit: number;

  constructor(param: Json) {
    if (typeof param == "number") this.limit = param;
    else this.limit = 25;
  }

  instantiate(collections: ResourceInputs): EagerCollection<number, Upvoted> {
    return collections.postsWithUpvotes.take(this.limit).map(SortingMapper);
  }
}

export const service: SkipService<{}, ResourceInputs> = {
  initialData: {},
  resources: { posts: PostsResource },
  externalServices: { postgres },
  createGraph(_: {}, context: Context): ResourceInputs {
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
    };
  },
};
