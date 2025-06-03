import { Link } from "react-router-dom";
import { useAuth } from "../contexts/AuthContext";

export function Header() {
  const { session, logout } = useAuth();

  return (
    <div className="header">
      <img src="/skip_white.svg" width="24" height="24" alt="Skip Logo" />
      <span className="title">Skip Blog</span>
      <span className="menu">
        <Link to="/">Home</Link>
        {session && <Link to="/submit">New Post</Link>}
      </span>
      <span className="login">
        {session ? (
          <>
            <span>Welcome, {session.name}</span>
            <button onClick={logout}>Logout</button>
          </>
        ) : (
          <Link to="/login">Login</Link>
        )}
      </span>
    </div>
  );
}
