import { type SetStateAction, useState, useEffect } from "react";
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
  //     const response = await fetch(BASE_URL);
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
    const evSource = new EventSource(BASE_URL);
    evSource.onmessage = (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data);
      const updatedPosts = data[0][1] as Post[];
      setPosts(updatedPosts);
    };
  }, []);

  async function upvotePost(postId: number) {
    try {
      await fetch(`${BASE_URL}/posts/${postId}/upvotes`, { method: "POST" });
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
  const post_id = parseInt(useParams().post_id!);
  const [post, setPost] = useState<Post | null>(null);

  async function getPost(postId: number) {
    try {
      const response = await fetch(`${BASE_URL}/posts/${postId}`);
      console.log(response);
      const data = (await response.json()) as SetStateAction<Post | null>;
      console.log(data);
      return data;
    } catch (error) {
      console.error(error);
    }
  }

  useEffect(() => {
    const intervalId = setInterval(() => {
      void getPost(post_id).then((post) =>
        post === undefined ? undefined : setPost(post),
      );
    }, 1000);

    return () => clearInterval(intervalId);
  }, [post_id]);

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
