import { useState, useEffect, useRef } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./App.css";
import { Post } from "./types";
import { Feed } from "./components/Feed";
import { Submit } from "./components/Submit";
import { Login } from "./components/Login";
import { AuthProvider } from "./contexts/AuthContext";

export default function App() {
  const [posts, setPosts] = useState<Post[]>([]);
  const previousPostsValue = useRef<Post[]>([]);

  useEffect(() => {
    const evSource = new EventSource("/api/posts");
    evSource.addEventListener("init", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data) as [number, any[]][];
      const initialPosts = data.map(([post_id, values]) => {
        return { ...values[0], id: post_id };
      }) as Post[];
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
          updatedPosts.push({ ...values[0], id: post_id });
        }
      }
      updatedPosts = updatedPosts.concat(
        previousPostsValue.current.filter(
          (post) => !modifiedPosts.includes(post.id),
        ),
      );
      setPosts(updatedPosts);
      previousPostsValue.current = updatedPosts;
    });
    return () => {
      evSource.close();
    };
  }, []);

  return (
    <AuthProvider>
      <Router>
        <div>
          <Routes>
            <Route path="/" element={<Feed posts={posts} />} />
            <Route path="/submit" Component={Submit} />
            <Route path="/login" Component={Login} />
          </Routes>
        </div>
      </Router>
    </AuthProvider>
  );
}
