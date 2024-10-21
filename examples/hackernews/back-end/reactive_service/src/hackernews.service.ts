import type {
  Context,
  TJSON,
  EagerCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
} from "@skipruntime/core";

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

export default class HackerNewsService implements SkipService {
  inputCollections = { posts: [], users: [], upvotes: [] };
  resources = { posts: PostsResource };

  reactiveCompute(
    _context: Context,
    inputCollections: {
      posts: EagerCollection<number, Post>;
      users: EagerCollection<number, User>;
      upvotes: EagerCollection<number, Upvote>;
    },
  ): Record<string, EagerCollection<TJSON, TJSON>> {
    const upvotes = inputCollections.upvotes.map(UpvotesMapper);
    const postsWithUpvotes = inputCollections.posts.map(
      PostsMapper,
      inputCollections.users,
      upvotes,
    );

    return {
      postsWithUpvotes,
    };
  }
}

class UpvotesMapper {
  mapElement(
    key: number,
    it: NonEmptyIterator<Upvote>,
  ): Iterable<[number, number]> {
    const value = it.first().post_id;
    return [[value, key]];
  }
}

class PostsMapper {
  constructor(
    private users: EagerCollection<number, User>,
    private upvotes: EagerCollection<number, number>,
  ) {}

  mapElement(
    key: number,
    it: NonEmptyIterator<Post>,
  ): Iterable<[[number, number], Upvoted]> {
    const post = it.first();
    const upvotes = this.upvotes.getArray(key).length;
    const author = this.users.maybeGetOne(post.author_id)!;
    return [[[-upvotes, key], { ...post, upvotes, author }]];
  }
}

class PostsCleanupKeyMapper {
  mapElement(
    key: [number, number],
    it: NonEmptyIterator<TJSON>,
  ): Iterable<[string, TJSON]> {
    const post = it.first();
    return [[key[1].toString(), post]];
  }
}

class PostsResource implements Resource {
  private limit: number;

  constructor(params: Record<string, string>) {
    console.log(params["limit"]);
    this.limit = Number(params["limit"]);
  }

  reactiveCompute(
    _context: Context,
    collections: {
      postsWithUpvotes: EagerCollection<[number, number], Upvoted>;
    },
  ): EagerCollection<string, TJSON> {
    // console.log("limit", this.limit);
    return collections.postsWithUpvotes
      .take(this.limit)
      .map(PostsCleanupKeyMapper);
  }
}
