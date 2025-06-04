import { useState, useEffect, useRef } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./App.css";
import { Post, Session } from "./components/types.js";
import Feed from "./components/Feed.js";
import Submit from "./components/Submit.js";
import Login from "./components/Login.js";

export default function App() {
  const [posts, setPosts] = useState<Post[]>([]);
  const previousPostsValue = useRef<Post[]>([]);
  const [session, setSession] = useState<Session | null>(null);

  function updateSession(data: [number, Session[]][]) {
    let session;
    if (data.length > 0 && data[0][1].length > 0) {
      session = data[0][1][0] as Session;
    } else {
      session = null;
    }
    setSession(session);
  }

  useEffect(() => {
    const evSource = new EventSource("/api/session");
    evSource.addEventListener("init", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data) as [number, Session[]][];
      updateSession(data);
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data) as [number, Session[]][];
      updateSession(data);
    });
    return () => {
      evSource.close();
    };
  }, []);

  useEffect(() => {
    const evSource = new EventSource("/api/posts");
    const sortByUpvotes = (a: Post, b: Post) => {
      if (a.upvotes == b.upvotes) return 0;
      if (a.upvotes < b.upvotes) return 1;
      return -1;
    };
    evSource.addEventListener("init", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data) as [number, any[]][];
      const initialPosts = data.map(([post_id, values]) => {
        values[0].date = new Date(values[0].date);
        return { ...values[0], id: post_id };
      }) as Post[];
      initialPosts.sort(sortByUpvotes);
      setPosts(initialPosts);
      previousPostsValue.current = initialPosts;
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data);
      let modifiedPosts: number[] = [];
      let updatedPosts: Post[] = [];
      for (let [post_id, values] of data) {
        modifiedPosts.push(post_id);
        if (values.length > 0) {
          values[0].date = new Date(values[0].date);
          updatedPosts.push({ ...values[0], id: post_id });
        }
      }
      updatedPosts = updatedPosts.concat(
        previousPostsValue.current.filter(
          (post: Post) => !modifiedPosts.includes(post.id),
        ),
      );
      updatedPosts.sort(sortByUpvotes);
      setPosts(updatedPosts);
      previousPostsValue.current = updatedPosts;
    });
    return () => {
      evSource.close();
    };
  }, []);

  return (
    <Router>
      <Routes>
        <Route path="/" element={<Feed posts={posts} session={session} />} />
        <Route path="/submit" Component={Submit} />
        <Route path="/login" Component={Login} />
      </Routes>
    </Router>
  );
}
