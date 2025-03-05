import { useState, useEffect, useRef } from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./App.css";

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" Component={Feed} />
      </Routes>
    </Router>
  );
}

type Message = {
  id: number;
  body: string;
  author: string;
  likedBy: string[];
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
          if (msg) newMessages.set(key, msg);
          else newMessages.delete(key);
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

  async function likeMessage(message_id: number) {
    try {
      await fetch(`/api/like`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          message_id,
          author: author == "" ? "(no name given)" : author,
        }),
      });
    } catch (error) {
      console.error(error);
    }
  }

  async function sendMessage() {
    try {
      await fetch(`/api/message`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          body,
          author: author == "" ? "(no name given)" : author,
        }),
      });
      setBody("");
    } catch (error) {
      console.error(error);
    }
  }

  const messagesRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    const element = messagesRef.current;
    element?.scrollBy(0, element.scrollHeight);
  }, [messages]);

  return (
    <div className="page">
      <h1>Reactive chat room example</h1>
      <div className="messages" ref={messagesRef}>
        {Array.from(messages.values())
          .sort((a, b) => a.id - b.id)
          .map((message) => {
            const messageClass =
              "message " +
              (message.author == author ||
              (message.author == "(no name given)" && author == "")
                ? "sent"
                : "received");
            const likeCount = message.likedBy.length;
            const likeButtonClass =
              "prevent-select likes " + (likeCount > 0 ? "liked" : "unliked");
            const likeCountClass =
              likeCount > 0 ? "likes-count-badge" : "hidden";
            return (
              <div className={messageClass}>
                <b>{message.author}:</b>
                <br />
                {message.body}&nbsp;
                <div
                  className={likeButtonClass}
                  onClick={() => void likeMessage(message.id)}
                >
                  <span className={likeCountClass}>{likeCount}</span>
                  <span className="liked-by-tooltip">
                    {"Liked by: " + message.likedBy.join(", ")}
                  </span>
                </div>
              </div>
            );
          })}
      </div>
      <br />
      <form
        className="new-message"
        onSubmit={(e) => {
          e.preventDefault();
          sendMessage();
        }}
      >
        <input
          type="text"
          placeholder="Name"
          value={author}
          className="author"
          onChange={(e) => setAuthor(e.target.value)}
        />
        <input
          type="text"
          placeholder="Message"
          value={body}
          className="body"
          onChange={(e) => setBody(e.target.value)}
        />
        <button type="submit">Send Message</button>
      </form>
    </div>
  );
}
