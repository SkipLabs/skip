import { useNavigate } from "react-router-dom";
import { useState } from "react";
import Header from "./Header.jsx";

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

export default Submit;
