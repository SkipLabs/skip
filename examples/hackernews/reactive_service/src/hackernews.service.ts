import type {
  Context,
  EagerCollection,
  Json,
  Values,
  Resource,
  SkipService,
} from "@skipruntime/core";

import { PostgresExternalService } from "@skip-adapter/postgres";
import type {
  Post,
  PostWithUpvoteIds,
  PostWithUpvoteCount,
  PostsServiceInputs,
  SessionsResourceInputs,
  PostsResourceInputs,
  PostsResourceParams,
  Session,
  Upvote,
  User,
} from "./types.js";

// Default user for posts where the author is not found
const unknownUser: User = { name: "unknown author", email: "unknown email" };

// Initialize PostgreSQL connection
const postgres = new PostgresExternalService({
  host: process.env["PG_HOST"] || "db",
  port: Number(process.env["PG_PORT"]) || 5432,
  database: process.env["PG_DATABASE"] || "postgres",
  user: process.env["PG_USER"] || "postgres",
  password: process.env["PG_PASSWORD"] || "change_me",
});

/**
 * Maps upvote entries to post_id and user_id pairs
 * Used to track which users have upvoted which posts
 */
class UpvotesMapper {
  mapEntry(_key: number, values: Values<Upvote>): Iterable<[number, number]> {
    const upvote: Upvote = values.getUnique();
    return [[upvote.post_id, upvote.user_id]];
  }
}

/**
 * Maps post entries to include author information and upvote IDs
 * Combines post data with user data and upvote information
 */
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
    // Sort by upvote count (negative for descending order) and post ID
    return [[[-upvotes.length, key], { ...post, upvotes, author }]];
  }
}

/**
 * Cleans up post data for client consumption
 * Adds upvote count and upvoted status for the current session
 */
class CleanupMapper {
  constructor(private readonly session: Session | null) {}

  mapEntry(
    key: [number, number],
    values: Values<PostWithUpvoteIds>,
  ): Iterable<[number, PostWithUpvoteCount]> {
    const post = values.getUnique();
    // Check if the current user has upvoted this post
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

/**
 * Resource handler for posts
 * Manages post retrieval with pagination and session context
 */
class PostsResource implements Resource<PostsResourceInputs> {
  private limit: number;
  private session_id: string;

  constructor(jsonParams: Json) {
    const params = jsonParams as PostsResourceParams;
    // Default to 25 posts if limit not specified
    if (params.limit === undefined) this.limit = 25;
    else this.limit = params.limit;
    if (params.session_id === undefined)
      throw new Error("Missing required session_id.");
    else this.session_id = params.session_id as string;
  }

  instantiate(
    collections: PostsResourceInputs,
  ): EagerCollection<number, PostWithUpvoteCount> {
    // Get current session or null if not logged in
    let session;
    try {
      session = collections.sessions.getUnique(this.session_id);
    } catch {
      session = null;
    }
    // Apply limit and cleanup for client consumption
    return collections.postsWithUpvotes
      .take(this.limit)
      .map(CleanupMapper, session);
  }
}

/**
 * Filters sessions to only return the current user's session
 */
class FilterSessionMapper {
  constructor(private session_id: string) {}

  mapEntry(key: string, values: Values<Session>): Iterable<[number, Session]> {
    if (key != this.session_id) return [];
    const sessions = values.toArray();
    if (sessions.length > 0) return [[0, sessions[0] as Session]];
    else return [];
  }
}

/**
 * Resource handler for sessions
 * Manages user session data
 */
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

/**
 * Main service definition
 * Configures resources, external services, and data flow
 */
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
    // Configure database resources with serial ID keys
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
