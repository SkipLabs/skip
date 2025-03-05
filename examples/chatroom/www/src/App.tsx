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
  const [messages, setMessages] = useState<Map<number, Message>>(
    new Map<number, Message>(),
  );
  const [author, setAuthor] = useState<string>("");
  const [body, setBody] = useState<string>("");

  useEffect(() => {
    const evSource = new EventSource("/api/messages");
    const listener = (e: MessageEvent<string>) => {
      const data = JSON.parse(e.data) as [number, Message[]][];
      setMessages((messages) => {
        const newMessages = new Map(messages);
        for (const [key, [msg]] of data) {
          newMessages.set(key, msg);
        }
        return newMessages;
      });
    };
    evSource.addEventListener("init", listener);
    evSource.addEventListener("update", listener);
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
        {Array.from(messages.values()).map((message) => (
          <li key={message.id}>
            <div
              className="votearrow prevent-select"
              title="upvote"
              onClick={() => void likeMessage(message.id)}
            ></div>
            &nbsp;
            {message.body}&nbsp; (--{message.author})&nbsp;
            <br />
            {message.likes} likes
          </li>
        ))}
      </ul>
    </>
  );
}
