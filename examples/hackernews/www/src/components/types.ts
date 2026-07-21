type Post = {
  id: number;
  title: string;
  body: string;
  date: Date;
  url: string;
  upvotes: number;
  upvoted: boolean;
  author: User;
};

type User = {
  name: string;
  email: string;
};

type Session = User & { id: string };

export type { User, Session, Post };
