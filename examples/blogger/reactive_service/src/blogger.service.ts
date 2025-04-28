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
  content: string;
  status: string;
  published_at: string | null;
  created_at: string;
  updated_at: string;
};

type User = {
  id: number;
  username: string;
  email: string;
};

const unknownUser: User = {
  id: 0,
  username: "unknown author",
  email: "unknown email",
};

type PostWithAuthor = Omit<Post, "author_id"> & {
  author: {
    name: string;
    email: string;
  };
};

const postgres = new PostgresExternalService({
  host: "blogger_db",
  port: 5432,
  database: "postgres",
  user: "postgres",
  password: "change_me",
});

class PostsMapper {
  constructor(private users: EagerCollection<number, User>) {}

  mapEntry(
    key: number,
    values: Values<Post>,
  ): Iterable<[number, PostWithAuthor]> {
    const post: Post = values.getUnique();
    let author;
    try {
      author = this.users.getUnique(post.author_id);
    } catch {
      author = unknownUser;
    }
    return [
      [
        key,
        {
          title: post.title,
          content: post.content,
          status: post.status,
          published_at: post.published_at,
          created_at: post.created_at,
          updated_at: post.updated_at,
          author: {
            name: author.username,
            email: author.email,
          },
        },
      ],
    ];
  }
}

type PostsResourceInputs = {
  posts: EagerCollection<number, PostWithAuthor>;
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
  ): EagerCollection<number, PostWithAuthor> {
    return collections.posts.take(this.limit);
  }
}

type PostsServiceInputs = Record<string, never>;

export const service: SkipService<PostsServiceInputs, PostsResourceInputs> = {
  initialData: {},
  resources: { posts: PostsResource },
  externalServices: { postgres },
  createGraph(
    _inputs: PostsServiceInputs,
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
    return {
      posts: posts.map(PostsMapper, users),
    };
  },
};
