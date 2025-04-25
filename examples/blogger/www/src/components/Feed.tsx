import { Post, Session } from "../types";
import { Header } from "./Header";

interface FeedProps {
  posts: Post[];
  session: Session | null;
}

export function Feed({ posts, session }: FeedProps) {
  function formatDate(date: string | null) {
    if (!date) return "Draft";
    return new Date(date).toLocaleDateString("en-US", {
      year: "numeric",
      month: "long",
      day: "numeric",
    });
  }

  return (
    <>
      <Header session={session} />
      <div className="body">
        <h1>Latest Posts</h1>
        {posts.length === 0 ? (
          <p>No posts yet. {session && "Create your first post!"}</p>
        ) : (
          posts.map((post) => (
            <article className="post" key={post.id}>
              <h2 className="posttitle">
                {post.title}
                <span className="status">{post.status}</span>
              </h2>
              <div className="content">{post.content}</div>
              <div className="subtext">
                By {post.author.name} • {formatDate(post.published_at)}
              </div>
            </article>
          ))
        )}
      </div>
    </>
  );
} 