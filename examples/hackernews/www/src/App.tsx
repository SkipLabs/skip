import { useState, useEffect, useRef } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
  useNavigate,
} from "react-router-dom";
import "./App.css";

type Post = {
  id: number;
  title: string;
  body: string;
  date: Date;
  url: string;
  upvotes: number;
  upvoted: boolean;
  author: User;
};

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

type User = {
  name: string;
  email: string;
};

type Session = User & { id: string };

function Header(props: { session: Session | null }) {
  function logout() {
    void fetch("/api/logout", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
    }).catch((err: unknown) => {
      console.log(err);
    });
  }

  const navigate = useNavigate();
  return (
    <div className="header">
      <img src="/skip_white.svg" width="16" height="16" />
      <span className="title">Skip News</span>
      <span className="menu">
        new | past | comments |{" "}
        <a
          href="#"
          onClick={(e) => {
            e.preventDefault();
            props.session !== null ? navigate("/submit") : navigate("/login");
          }}
        >
          submit
        </a>
      </span>
      <span className="login">
        {props.session && (
          <>
            {props.session.name} |{" "}
            <a
              href="#"
              onClick={(e) => {
                e.preventDefault();
                logout();
              }}
            >
              logout
            </a>
          </>
        )}
        {!props.session && <Link to="/login">login</Link>}
      </span>
    </div>
  );
}

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

function Submit() {
  const navigate = useNavigate();
  const [newPost, setNewPost] = useState<{
    title: string;
    body: string;
    url: string;
  }>({ title: "", body: "", url: "" });
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

  return (
    <>
      <Header session={null} />
      <div className="body">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            createPost().then((_) => navigate("/"));
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
      </div>
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
      <Header session={null} />
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
