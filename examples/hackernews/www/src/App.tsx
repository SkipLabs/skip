import { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./App.css";

export default function App() {
  return (
    <Router>
      <div>
        <Routes>
          <Route path="/" Component={Feed} />
        </Routes>
      </div>
    </Router>
  );
}

type Post = {
  id: number;
  title: string;
  body: string;
  url: string;
  upvotes: number;
};

function Feed() {
  const [posts, setPosts] = useState<Post[]>([]);

  // // Non-reactive (polling) version:
  // async function getPosts() {
  //   try {
  //     const response = await fetch("/");
  //     const data = await response.json();
  //     return data;
  //   } catch (error) {
  //     console.error(error);
  //   }
  // }

  // async function upvotePost(postId: number) {
  //   try {
  //     await fetch(`${BASE_URL}/posts/${postId}/upvotes`, { method: "POST" });
  //     getPosts().then(setPosts);
  //   } catch (error) {
  //     console.error(error);
  //   }
  // }

  // useEffect(() => {
  //   const intervalId = setInterval(() => {
  //     getPosts().then(setPosts);
  //   }, 1000);

  //   return () => clearInterval(intervalId);
  // }, []);

  // Reactive version:
  useEffect(() => {
    const evSource = new EventSource("/api/posts");
    evSource.addEventListener("init", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data);
      const updatedPosts = data[0][1] as Post[];
      setPosts(updatedPosts);
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data);
      const updatedPosts = data[0][1] as Post[];
      setPosts(updatedPosts);
    });
  }, []);

  async function upvotePost(postId: number) {
    try {
      await fetch(`/api/posts/${postId}/upvotes`, { method: "POST" });
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <>
      <h1>HackerNews example</h1>
      <ul>
        {posts.map((post) => (
          <li key={post.id}>
            <div
              className="votearrow prevent-select"
              title="upvote"
              onClick={() => void upvotePost(post.id)}
            ></div>
            &nbsp;
            {post.title}&nbsp;
            <a href={post.url}>({post.url})</a>
            <br />
            {post.upvotes} points
          </li>
        ))}
      </ul>
    </>
  );
}
