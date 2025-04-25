import { useState } from "react";
import { Header } from "./Header";

export function Login() {
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
      .then((data) => {
        if (data) {
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