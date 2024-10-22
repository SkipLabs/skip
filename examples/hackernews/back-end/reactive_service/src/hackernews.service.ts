import type {
  Context,
  Entry,
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
  inputCollections: {
    posts: Entry<string, Post>[];
    users: Entry<string, User>[];
    upvotes: Entry<string, Upvote>[];
  };
  resources = { posts: PostsResource };

  constructor(
    posts: Entry<string, Post>[],
    users: Entry<string, User>[],
    upvotes: Entry<string, Upvote>[],
  ) {
    this.inputCollections = { posts, users, upvotes };
  }

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
  ): Iterable<[number, Upvoted]> {
    const post = it.first();
    const upvotes = this.upvotes.getArray(key).length;
    const author = this.users.maybeGetOne(post.author_id)!;
    // Projecting all posts on key 0 so that they can later be sorted.
    return [[0, { ...post, upvotes, author }]];
  }
}

class SortingMapper {
  mapElement(
    key: number,
    it: NonEmptyIterator<Upvoted>,
  ): Iterable<[number, Upvoted]> {
    const posts = it.toArray();
    // Sorting in descending order of upvotes.
    posts.sort((a, b) => b.upvotes - a.upvotes);
    return posts.map((p) => [key, p]);
  }
}

class PostsResource implements Resource {
  private limit: number;

  constructor(params: Record<string, string>) {
    this.limit = Number(params["limit"]);
  }

  reactiveCompute(
    _context: Context,
    collections: {
      postsWithUpvotes: EagerCollection<number, Upvoted>;
    },
  ): EagerCollection<number, Upvoted> {
    return collections.postsWithUpvotes.take(this.limit).map(SortingMapper);
  }
}
