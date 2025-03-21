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
  date: number;
};

type User = {
  name: string;
  email: string;
};

type Upvote = {
  post_id: number;
  user_id: number;
};

type PostWithUpvoteIds = Post & { upvotes: number[]; author: User };

type PostWithUpvoteCount = Omit<Post, "author_id"> & {
  upvotes: number;
  upvoted: boolean;
  author: User;
};

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
      author = { name: "unknown author", email: "unknown email" };
    }
    return [[[-upvotes.length, key], { ...post, upvotes, author }]];
  }
}

class CleanupMapper {
  private readonly session: Session | null;

  constructor(session: Json | null) {
    this.session = session as Session | null;
  }

  mapEntry(
    key: [number, number],
    values: Values<PostWithUpvoteIds>,
  ): Iterable<[number, PostWithUpvoteCount]> {
    const post = values.getUnique();
    let upvoted;
    if (this.session === null) upvoted = false;
    else upvoted = post.upvotes.includes(this.session.user_id);
    const upvotes = post.upvotes.length;
    return [
      [
        key[1],
        {
          title: post.title,
          url: post.url,
          body: post.body,
          date: post.date,
          author: post.author,
          upvotes,
          upvoted,
        },
      ],
    ];
  }
}

type PostsResourceInputs = {
  postsWithUpvotes: EagerCollection<[number, number], PostWithUpvoteIds>;
};

type PostsResourceParams = { limit?: number };

class PostsResource implements Resource<PostsResourceInputs> {
  private limit: number;

  constructor(jsonParams: Json) {
    const params = jsonParams as PostsResourceParams;
    if (params.limit === undefined) this.limit = 25;
    else this.limit = params.limit;
  }

  instantiate(
    collections: PostsResourceInputs,
    context: Context,
  ): EagerCollection<number, PostWithUpvoteCount> {
    return collections.postsWithUpvotes
      .take(this.limit)
      .map(CleanupMapper, context.session);
  }
}

export const service: SkipService<{}, PostsResourceInputs> = {
  resources: { posts: PostsResource },
  externalServices: { postgres },
  createGraph(_inputs: {}, context: Context): PostsResourceInputs {
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
