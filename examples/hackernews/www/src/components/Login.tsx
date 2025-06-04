import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Header from "./Header.jsx";

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

export default Login;
