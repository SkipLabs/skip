import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import Header from "./Header.jsx";
import { Session, Post } from "./types.js";

function Feed(props: { posts: Post[]; session: Session | null }) {
  function timeSince(curDate: Date, date: Date) {
    const seconds = Math.floor((curDate.getTime() - date.getTime()) / 1000);
    if (seconds < 60) {
      if (seconds == 1) return "1 second";
      return `${seconds} seconds`;
    }
    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) {
      if (minutes == 1) return "1 minute";
      return `${minutes} minutes`;
    }
    const hours = Math.floor(seconds / 3600);
    if (hours < 24) {
      if (hours == 1) return "1 hour";
      return `${hours} hours`;
    }
    const days = Math.floor(seconds / 86400);
    if (days == 1) return "1 day";
    return `${days} days`;
  }

  const [curDate, setCurDate] = useState<Date>(new Date());
  useEffect(() => {
    const interval = setInterval(() => {
      setCurDate(new Date());
    }, 1000);

    return () => clearInterval(interval);
  });

  const posts = props.posts;
  const session = props.session;
  const navigate = useNavigate();

  function toggleUpvote(post: Post) {
    let method = post.upvoted ? "DELETE" : "PUT";
    void fetch(`/api/posts/${post.id}/upvotes`, { method }).catch(
      (err: unknown) => {
        console.error(err);
      },
    );
  }

  function simulateActivity() {
    void fetch("/api/simulate_activity", { method: "POST" }).catch(
      (err: unknown) => {
        console.error(err);
      },
    );
  }

  return (
    <>
      <Header session={session} />
      <div className="body">
        <ol>
          {posts.map((post) => (
            <li className="post" key={post.id}>
              <p className="title">
                <div
                  className={post.upvoted ? "votearrow-active" : "votearrow"}
                  title="upvote"
                  onClick={() =>
                    session !== null ? toggleUpvote(post) : navigate("/login")
                  }
                ></div>
                <span className="posttitle">
                  <a href={post.url}>{post.title}</a>
                </span>
                <span className="comhead">
                  <a href="#">({post.url})</a>
                </span>
              </p>
              <p className="subtext">
                {post.upvotes} points by {post.author.name}{" "}
                {timeSince(curDate, post.date)} ago
              </p>
            </li>
          ))}
        </ol>
      </div>
      <button
        onClick={(e) => {
          e.preventDefault();
          simulateActivity();
        }}
      >
        Simulate activity
      </button>
    </>
  );
}

export default Feed;
