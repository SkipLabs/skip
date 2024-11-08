import type {
  Entry,
  Json,
  EagerCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
} from "skip-wasm";

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
  initialData: {
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
    this.initialData = { posts, users, upvotes };
  }

  createGraph(inputCollections: {
    posts: EagerCollection<number, Post>;
    users: EagerCollection<number, User>;
    upvotes: EagerCollection<number, Upvote>;
  }): Record<string, EagerCollection<Json, Json>> {
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
  mapEntry(
    key: number,
    values: NonEmptyIterator<Upvote>,
  ): Iterable<[number, number]> {
    const value = values.getUnique().post_id;
    return [[value, key]];
  }
}

class PostsMapper {
  constructor(
    private users: EagerCollection<number, User>,
    private upvotes: EagerCollection<number, number>,
  ) {}

  mapEntry(
    key: number,
    values: NonEmptyIterator<Post>,
  ): Iterable<[number, Upvoted]> {
    const post = values.getUnique();
    const upvotes = this.upvotes.getArray(key).length;
    const author = this.users.getUnique(post.author_id);
    // Projecting all posts on key 0 so that they can later be sorted.
    return [[0, { ...post, upvotes, author }]];
  }
}

class SortingMapper {
  mapEntry(
    key: number,
    values: NonEmptyIterator<Upvoted>,
  ): Iterable<[number, Upvoted]> {
    const posts = values.toArray();
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

  instantiate(collections: {
    postsWithUpvotes: EagerCollection<number, Upvoted>;
  }): EagerCollection<number, Upvoted> {
    return collections.postsWithUpvotes.take(this.limit).map(SortingMapper);
  }
}
