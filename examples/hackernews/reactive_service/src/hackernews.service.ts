import type {
  EagerCollection,
  Entry,
  Json,
  Values,
  Resource,
  SkipService,
} from "@skipruntime/runtime";

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

type Inputs = {
  posts: EagerCollection<number, Post>;
  users: EagerCollection<number, User>;
  upvotes: EagerCollection<number, Upvote>;
};
type ResourceInputs = {
  postsWithUpvotes: EagerCollection<number, Upvoted>;
};

export function serviceWithInitialData(
  posts: Entry<number, Post>[],
  users: Entry<number, User>[],
  upvotes: Entry<number, Upvote>[],
): SkipService<Inputs, ResourceInputs> {
  return {
    initialData: { posts, users, upvotes },
    resources: { posts: PostsResource },
    createGraph: (inputCollections: Inputs): ResourceInputs => {
      return {
        postsWithUpvotes: inputCollections.posts.map(
          PostsMapper,
          inputCollections.users,
          inputCollections.upvotes.map(UpvotesMapper),
        ),
      };
    },
  };
}

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
