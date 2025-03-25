import type {
  Context,
  EagerCollection,
  Json,
  Values,
  Resource,
  SkipService,
} from "@skipruntime/core";

import { SkipExternalService } from "@skipruntime/helpers";

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

type PostWithUpvoteIds = Post & { upvotes: number[]; author: User };

type PostWithUpvoteCount = Omit<Post, "author_id"> & {
  upvotes: number;
  upvoted: boolean;
  author: User;
};

type Session = User & {
  user_id: number;
};

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

type ResourceInputs = {
  postsWithUpvotes: EagerCollection<[number, number], PostWithUpvoteIds>;
  sessions: EagerCollection<string, Session>;
};

type PostsResourceParams = { limit?: number; session_id?: string };

class PostsResource implements Resource<ResourceInputs> {
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
    collections: ResourceInputs,
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

class SessionsResource implements Resource<ResourceInputs> {
  private session_id: string;

  constructor(jsonParams: Json) {
    const params = jsonParams as PostsResourceParams;
    if (params.session_id === undefined)
      throw new Error("Missing required session_id.");
    else this.session_id = params.session_id as string;
  }

  instantiate(collections: ResourceInputs): EagerCollection<number, Session> {
    return collections.sessions.map(FilterSessionMapper, this.session_id);
  }
}

export const service: SkipService<{}, ResourceInputs> = {
  initialData: {},
  resources: { posts: PostsResource, sessions: SessionsResource },
  externalServices: {
    leader: SkipExternalService.direct({
      host: "skip_leader",
      streaming_port: 8080,
      control_port: 8081,
    }),
  },
  createGraph(_inputs: {}, context: Context): ResourceInputs {
    const postsWithUpvotes = context.useExternalResource<
      [number, number],
      PostWithUpvoteIds
    >({
      service: "leader",
      identifier: "postsWithUpvotes",
      params: {},
    });
    const sessions = context.useExternalResource<string, Session>({
      service: "leader",
      identifier: "sessions",
      params: {},
    });
    return { postsWithUpvotes, sessions };
  },
};
