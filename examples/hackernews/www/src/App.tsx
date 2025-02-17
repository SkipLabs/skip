import { useState, useEffect, useRef } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
  useNavigate,
} from "react-router-dom";
import "./App.css";

type Session = {
  id: string;
  name: string;
  email: string;
};

export default function App() {
  return (
    <Router>
      <div>
        <Routes>
          <Route path="/" Component={Feed} />
          <Route path="/login" Component={Login} />
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
  upvoted: boolean;
};

function Feed() {
  const navigate = useNavigate();
  const [posts, setPosts] = useState<Post[]>([]);
  const previousPostsValue = useRef<Post[]>([]);
  const [newPost, setNewPost] = useState<{
    title: string;
    body: string;
    url: string;
  }>({ title: "", body: "", url: "" });
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
          updatedPosts.push({ ...values[0], id: post_id });
        }
      }
      updatedPosts = updatedPosts.concat(
        previousPostsValue.current.filter(
          (post) => !modifiedPosts.includes(post.id),
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

  function toggleUpvote(post: Post) {
    let method = post.upvoted ? "DELETE" : "PUT";
    void fetch(`/api/posts/${post.id}/upvotes`, { method }).catch(
      (err: unknown) => {
        console.error(err);
      },
    );
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

  function logout() {
    void fetch("/api/logout", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
    }).catch((err: unknown) => {
      console.log(err);
    });
  }

  return (
    <>
      <h1>HackerNews example</h1>
      {session && (
        <p>
          {session.name}{" "}
          <a
            href="#"
            onClick={(e) => {
              e.preventDefault();
              logout();
            }}
          >
            Logout
          </a>
        </p>
      )}
      {!session && <Link to="/login">Login</Link>}
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
              className={post.upvoted ? "votearrow-active" : "votearrow"}
              title="upvote"
              onClick={() =>
                session !== null ? toggleUpvote(post) : navigate("/login")
              }
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

function Login() {
  const [email, setEmail] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const [loginError, setLoginError] = useState<string | null>();
  const navigate = useNavigate();
  function login(email: string, _password: string) {
    fetch("/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email,
        password,
      }),
    })
      .then((resp) => {
        if (!resp.ok) setLoginError("Invalid credentials");
        else navigate("/");
      })
      .catch((err: unknown) => {
        console.log(err);
        setLoginError("Login error");
      });
  }

  return (
    <>
      <h1>HackerNews example</h1>
      {loginError !== null && <p style={{ color: "red" }}>{loginError}</p>}
      <form
        onSubmit={(e) => {
          e.preventDefault();
          setLoginError(null);
          login(email, password);
        }}
      >
        <input
          type="text"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          disabled
        />
        <button type="submit">Login</button>
      </form>
    </>
  );
}
