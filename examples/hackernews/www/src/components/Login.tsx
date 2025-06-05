import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Header from "./Header.jsx";

function Login() {
  const [username, setUsername] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const [loginError, setLoginError] = useState<string | null>();
  const navigate = useNavigate();
  function login(username: string, _password: string) {
    fetch("/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        username,
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
      <p className="login-explanation">
        You can log in as any of these SkipLabs team members to experience the
        voting system: Benno, Charles, Daniel, Hugo, Josh, Julien, Laure, Lucas,
        Mehdi
      </p>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          setLoginError(null);
          login(username, password);
        }}
      >
        <input
          type="text"
          placeholder="Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
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

export default Login;
