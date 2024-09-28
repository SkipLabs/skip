import { useState, useEffect } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
  useParams,
} from "react-router-dom";
import "./App.css";

const BASE_URL = "http://localhost:5000";

export default function App() {
  return (
    <Router>
      <div>
        <Routes>
          <Route path="/" Component={Feed} />
          <Route path="/posts/:post_id" Component={Post} />
        </Routes>
      </div>
    </Router>
  );
}

function Feed() {
  const [posts, setPosts] = useState([]);

  async function getPosts() {
    try {
      const response = await fetch(BASE_URL);
      const data = await response.json();
      return data;
    } catch (error) {
      console.error(error);
    }
  }

  async function upvotePost(postId) {
    try {
      await fetch(`${BASE_URL}/posts/${postId}/upvotes`, { method: "POST" });
      getPosts().then(setPosts);
    } catch (error) {
      console.error(error);
    }
  }

  useEffect(() => {
    const intervalId = setInterval(() => {
      getPosts().then(setPosts);
    }, 1000);

    return () => clearInterval(intervalId);
  }, []);

  return (
    <>
      <h1>HackerNews example</h1>
      <ul>
        {posts.map((post) => (
          <li key={post.id}>
            <div
              className="votearrow"
              title="upvote"
              onClick={() => upvotePost(post.id)}
            ></div>
            &nbsp;
            <Link to={`/posts/${post.id}`}>{post.title}</Link>&nbsp;
            <a href={post.url}>({post.url})</a>
            <br />
            {post.upvotes} points
          </li>
        ))}
      </ul>
    </>
  );
}

function Post() {
  const post_id = useParams().post_id;
  const [post, setPost] = useState(null);

  async function getPost(postId) {
    try {
      const response = await fetch(`${BASE_URL}/posts/${postId}`);
      console.log(response);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (error) {
      console.error(error);
    }
  }

  useEffect(() => {
    const intervalId = setInterval(() => {
      getPost(post_id).then(setPost);
    }, 1000);

    return () => clearInterval(intervalId);
  }, []);

  return (
    <>
      <h1>HackerNews example</h1>
      {post && (
        <>
          <h2>{post.title}</h2>
          <p>{post.body}</p>
        </>
      )}
    </>
  );
}
