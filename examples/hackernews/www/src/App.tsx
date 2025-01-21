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
  const [newPost, setNewPost] = useState<{title: string, body: string, url: string}>({ title: "", body: "", url: "" });
  const [editPost, setEditPost] = useState<Post | null>(null);

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
      const initialPosts = data[0][1] as Post[];
      setPosts(initialPosts);
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data);
      const updatedPosts = data[0][1] as Post[];
      setPosts(updatedPosts);
    });
    return () => {
      evSource.close();
    };
  }, []);

  async function upvotePost(postId: number) {
    try {
      await fetch(`/api/posts/${postId}/upvotes`, { method: "POST" });
    } catch (error) {
      console.error(error);
    }
  }

  async function deletePost(postId: number) {
    try {
      await fetch(`/api/posts/${postId}`, { method: "DELETE" });
    } catch (error) {
      console.error(error);
    }
  }

  async function createPost() {
    try {
      await fetch(`/api/posts`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(newPost),
      });
      setNewPost({ title: "", body: "", url: "" });
    } catch (error) {
      console.error(error);
    }
  }

  async function updatePost(postId: number) {
    try {
      await fetch(`/api/posts/${postId}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(editPost),
      });
      setEditPost(null);
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <>
      <h1>HackerNews example</h1>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          createPost();
        }}
      >
        <input
          type="text"
          placeholder="Title"
          value={newPost.title}
          onChange={(e) => setNewPost({ ...newPost, title: e.target.value })}
        />
        <input
          type="text"
          placeholder="Body"
          value={newPost.body}
          onChange={(e) => setNewPost({ ...newPost, body: e.target.value })}
        />
        <input
          type="text"
          placeholder="URL"
          value={newPost.url}
          onChange={(e) => setNewPost({ ...newPost, url: e.target.value })}
        />
        <button type="submit">Create Post</button>
      </form>
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
            <button onClick={() => deletePost(post.id)}>Delete</button>
            <button onClick={() => setEditPost(post)}>Edit</button>
          </li>
        ))}
      </ul>
      {editPost && (
        <form
          onSubmit={(e) => {
            e.preventDefault();
            updatePost(editPost.id);
          }}
        >
          <input
            type="text"
            placeholder="Title"
            value={editPost.title}
            onChange={(e) =>
              setEditPost({ ...editPost, title: e.target.value })
            }
          />
          <input
            type="text"
            placeholder="Body"
            value={editPost.body}
            onChange={(e) => setEditPost({ ...editPost, body: e.target.value })}
          />
          <input
            type="text"
            placeholder="URL"
            value={editPost.url}
            onChange={(e) => setEditPost({ ...editPost, url: e.target.value })}
          />
          <button type="submit">Update Post</button>
        </form>
      )}
    </>
  );
}
