import type { EagerCollection } from "@skipruntime/core";

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

type PostsServiceInputs = {
  sessions: EagerCollection<string, Session>;
};

type PostsResourceInputs = {
  postsWithUpvotes: EagerCollection<[number, number], PostWithUpvoteIds>;
  sessions: EagerCollection<string, Session>;
};

type PostsResourceParams = { limit?: number; session_id?: string };

type SessionsResourceInputs = {
  sessions: EagerCollection<string, Session>;
};

export type {
  Post,
  User,
  Upvote,
  PostWithUpvoteIds,
  SessionsResourceInputs,
  PostWithUpvoteCount,
  PostsResourceInputs,
  PostsResourceParams,
  Session,
  PostsServiceInputs,
};
