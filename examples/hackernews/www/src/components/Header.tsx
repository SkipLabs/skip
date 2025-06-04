import { Session } from "./types.jsx";
import { Link } from "react-router-dom";
import { useNavigate } from "react-router-dom";

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

export default Header;
