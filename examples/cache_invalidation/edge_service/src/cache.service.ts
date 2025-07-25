/**
 * Automated Cache Invalidation Service
 * 
 * This service demonstrates Skip's automatic cache invalidation capabilities:
 * - Database changes are automatically detected
 * - Cache entries are invalidated without manual intervention
 * - Updates propagate to all connected clients in real-time
 */

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

// PostgreSQL adapter monitors database changes and triggers cache invalidation
const postgres = new PostgresExternalService({
  host: "invalidation_db",
  port: 5432,
  database: "postgres",
  user: "postgres",
  password: "change_me",
});

/**
 * PostsMapper demonstrates reactive relationships:
 * When a user record changes, all posts by that user are automatically
 * invalidated in the cache, ensuring consistency.
 */
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
    
    // useExternalResource automatically monitors the PostgreSQL tables
    // Any INSERT, UPDATE, or DELETE triggers automatic cache invalidation
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
    
    // The map operation creates reactive dependencies:
    // - Changes to posts invalidate the specific post cache entry
    // - Changes to users invalidate all posts by that user
    return {
      posts: posts.map(PostsMapper, users),
    };
  },
};
