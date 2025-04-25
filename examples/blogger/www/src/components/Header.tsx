import { Link } from "react-router-dom";
import { Session } from "../types";

interface HeaderProps {
  session: Session | null;
}

export function Header({ session }: HeaderProps) {
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
        {session && <Link to="/submit">New Post</Link>}
      </span>
      <span className="login">
        {session ? (
          <>
            <span>Welcome, {session.name}</span>
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