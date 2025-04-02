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
const unknownUser: User = { name: "unknown author", email: "unknown email" };

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
      author = unknownUser;
    }
    return [[[-upvotes.length, key], { ...post, upvotes, author }]];
  }
}

class CleanupMapper {
  constructor(private readonly session: Session | null) {}

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
  sessions: EagerCollection<string, Session>;
};

type PostsResourceParams = { limit?: number; session_id?: string };

class PostsResource implements Resource<PostsResourceInputs> {
  private limit: number;
  private session_id: string;

  constructor(jsonParams: Json) {
    const params = jsonParams as PostsResourceParams;
    if (params.limit === undefined) this.limit = 25;
    else this.limit = params.limit;
    if (params.session_id === undefined)
      throw new Error("Missing required session_id.");
    else this.session_id = params.session_id as string;
  }

  instantiate(
    collections: PostsResourceInputs,
  ): EagerCollection<number, PostWithUpvoteCount> {
    let session;
    try {
      session = collections.sessions.getUnique(this.session_id);
    } catch {
      session = null;
    }
    return collections.postsWithUpvotes
      .take(this.limit)
      .map(CleanupMapper, session);
  }
}

class FilterSessionMapper {
  constructor(private session_id: string) {}

  mapEntry(key: string, values: Values<Session>): Iterable<[number, Session]> {
    if (key != this.session_id) return [];
    const sessions = values.toArray();
    if (sessions.length > 0) return [[0, sessions[0] as Session]];
    else return [];
  }
}

type SessionsResourceInputs = {
  sessions: EagerCollection<string, Session>;
};

class SessionsResource implements Resource<SessionsResourceInputs> {
  private session_id: string;

  constructor(jsonParams: Json) {
    const params = jsonParams as PostsResourceParams;
    if (params.session_id === undefined)
      throw new Error("Missing required session_id.");
    else this.session_id = params.session_id as string;
  }

  instantiate(
    collections: SessionsResourceInputs,
  ): EagerCollection<number, Session> {
    return collections.sessions.map(FilterSessionMapper, this.session_id);
  }
}

type PostsServiceInputs = {
  sessions: EagerCollection<string, Session>;
};

export const service: SkipService<PostsServiceInputs, PostsResourceInputs> = {
  initialData: {
    sessions: [],
  },
  resources: { posts: PostsResource, sessions: SessionsResource },
  externalServices: { postgres },
  createGraph(
    inputs: PostsServiceInputs,
    context: Context,
  ): PostsResourceInputs {
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
