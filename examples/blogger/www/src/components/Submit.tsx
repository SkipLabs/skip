import { useState } from "react";
import { Header } from "./Header";

export function Submit() {
  const [newPost, setNewPost] = useState<{
    title: string;
    content: string;
    status: string;
  }>({ title: "", content: "", status: "draft" });

  async function createPost() {
    try {
      await fetch(`/api/posts`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(newPost),
      });
      setNewPost({ title: "", content: "", status: "draft" });
    } catch (error) {
      console.error(error);
    }
  }

  return (
    <>
      <Header session={null} />
      <div className="body">
        <h1>Create New Post</h1>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            createPost();
          }}
        >
          <input
            type="text"
            placeholder="Post Title"
            value={newPost.title}
            onChange={(e) => setNewPost({ ...newPost, title: e.target.value })}
            required
          />
          <textarea
            placeholder="Write your post content here..."
            value={newPost.content}
            onChange={(e) =>
              setNewPost({ ...newPost, content: e.target.value })
            }
            required
          />
          <select
            value={newPost.status}
            onChange={(e) => setNewPost({ ...newPost, status: e.target.value })}
          >
            <option value="draft">Save as Draft</option>
            <option value="published">Publish Now</option>
          </select>
          <button type="submit">
            {newPost.status === "draft" ? "Save Draft" : "Publish Post"}
          </button>
        </form>
      </div>
    </>
  );
} 