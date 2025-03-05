import { useState, useEffect } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./App.css";

export default function App() {
  return (
    <Router>
      <div>
        <Routes>
          <Route path="/" Component={Feed} />
        </Routes>
      </div>
    </Router>
  );
}

type Message = {
  id: number;
  body: string;
  author: string;
  likes: number;
};

function Feed() {
  const [messages, setMessages] = useState<Message[]>([]);
  const [author, setAuthor] = useState<string>("");
  const [body, setBody] = useState<string>("");

  useEffect(() => {
    const evSource = new EventSource("/api/messages");
    evSource.addEventListener("init", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data);
      console.log("initial data: ", data);
      setMessages(data[0][1] as Message[]);
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data);
      console.log("updated data: ", data);
      setMessages(data[0][1] as Message[]);
    });
    return () => {
      evSource.close();
    };
  }, []);

  async function likeMessage(id: number) {
    try {
      await fetch(`/api/like/${id}`, { method: "PUT" });
    } catch (error) {
      console.error(error);
    }
  }

  async function sendMessage() {
    try {
      await fetch(`/api/message`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ body, author }),
      });
      setBody("");
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <>
      <h1>Reactive chat room example</h1>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          sendMessage();
        }}
      >
        <input
          type="text"
          placeholder="Author"
          value={author}
          onChange={(e) => setAuthor(e.target.value)}
        />
        <input
          type="text"
          placeholder="Body"
          value={body}
          onChange={(e) => setBody(e.target.value)}
        />
        <button type="submit">Send Message</button>
      </form>
      <ul>
        {messages.map((message) => (
          <li key={message.id}>
            <div
              className="votearrow prevent-select"
              title="upvote"
              onClick={() => void likeMessage(message.id)}
            ></div>
            &nbsp;
            {message.author}&nbsp;
            <br />
            {message.likes} likes
          </li>
        ))}
      </ul>
    </>
  );
}
