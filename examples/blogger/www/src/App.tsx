import { useState, useEffect, useRef } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
} from "react-router-dom";
import "./App.css";

type Post = {
  id: number;
  title: string;
  content: string;
  status: string;
  published_at: string | null;
  author: User;
};

type User = {
  name: string;
  email: string;
};

type Session = User & { user_id: number };

export default function App() {
  const [posts, setPosts] = useState<Post[]>([]);
  const previousPostsValue = useRef<Post[]>([]);
  const [session, setSession] = useState<Session | null>(null);

  // Check for existing session on load
  useEffect(() => {
    fetch("/api/session")
      .then(res => res.json())
      .then(data => {
        if (data && data.user_id) {
          setSession(data);
        }
      })
      .catch(err => console.error("Session check failed:", err));
  }, []);

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
    <Router>
      <div>
        <Routes>
          <Route path="/" element={<Feed posts={posts} session={session} />} />
          <Route path="/submit" Component={Submit} />
          <Route path="/login" Component={Login} />
        </Routes>
      </div>
    </Router>
  );
}

function Header(props: { session: Session | null }) {
  function logout() {
    void fetch("/api/logout", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
    }).catch((err: unknown) => {
      console.log(err);
    });
  }

  return (
    <div className="header">
      <img src="/skip_white.svg" width="24" height="24" alt="Skip Logo" />
      <span className="title">Skip Blog</span>
      <span className="menu">
        <Link to="/">Home</Link>
        {props.session && (
          <Link to="/submit">New Post</Link>
        )}
      </span>
      <span className="login">
        {props.session ? (
          <>
            <span>Welcome, {props.session.name}</span>
            <a
              href="#"
              onClick={(e) => {
                e.preventDefault();
                logout();
              }}
            >
              Logout
            </a>
          </>
        ) : (
          <Link to="/login">Login</Link>
        )}
      </span>
    </div>
  );
}

function Feed(props: { posts: Post[]; session: Session | null }) {
  function formatDate(date: string | null) {
    if (!date) return "Draft";
    return new Date(date).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  }

  const posts = props.posts;
  const session = props.session;

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

function Submit() {
  const [newPost, setNewPost] = useState<{
    title: string;
    content: string;
    status: string;
  }>({ title: "", content: "", status: "draft" });

  async function createPost() {
    try {
      await fetch(`/api/posts`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(newPost),
      });
      setNewPost({ title: "", content: "", status: "draft" });
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <>
      <Header session={null} />
      <div className="body">
        <h1>Create New Post</h1>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            createPost();
          }}
        >
          <input
            type="text"
            placeholder="Post Title"
            value={newPost.title}
            onChange={(e) => setNewPost({ ...newPost, title: e.target.value })}
            required
          />
          <textarea
            placeholder="Write your post content here..."
            value={newPost.content}
            onChange={(e) => setNewPost({ ...newPost, content: e.target.value })}
            required
          />
          <select
            value={newPost.status}
            onChange={(e) => setNewPost({ ...newPost, status: e.target.value })}
          >
            <option value="draft">Save as Draft</option>
            <option value="published">Publish Now</option>
          </select>
          <button type="submit">
            {newPost.status === "draft" ? "Save Draft" : "Publish Post"}
          </button>
        </form>
      </div>
    </>
  );
}

function Login() {
  const [email, setEmail] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const [loginError, setLoginError] = useState<string | null>();

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
        if (!resp.ok) {
          setLoginError("Invalid credentials");
        } else {
          return resp.json();
        }
      })
      .then(data => {
        if (data) {
          // Set the session in the parent component
          window.location.href = "/"; // Force a refresh to update the session
        }
      })
      .catch((err: unknown) => {
        console.log(err);
        setLoginError("Login error");
      });
  }

  return (
    <>
      <Header session={null} />
      <div className="body">
        <h1>Login</h1>
        {loginError && <p style={{ color: "red" }}>{loginError}</p>}
        <form
          onSubmit={(e) => {
            e.preventDefault();
            setLoginError(null);
            login(email, password);
          }}
        >
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
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
      </div>
    </>
  );
}
