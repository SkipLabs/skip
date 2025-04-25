export type Post = {
  id: number;
  title: string;
  content: string;
  status: string;
  published_at: string | null;
  author: User;
};

export type User = {
  name: string;
  email: string;
};

export type Session = User & { user_id: number };
