<template>
  <div class="body">
    <div class="content-wrapper">
      <div class="main-content">
        <h1>Create New Post</h1>
        <form @submit.prevent="handleSubmit">
          <input
            type="text"
            placeholder="Post Title"
            v-model="newPost.title"
            required
          />
          <textarea
            placeholder="Write your post content here..."
            v-model="newPost.content"
            required
          />
          <select v-model="newPost.status">
            <option value="draft">Save as Draft</option>
            <option value="published">Publish Now</option>
          </select>
          <button type="submit">
            {{ newPost.status === "draft" ? "Save Draft" : "Publish Post" }}
          </button>
        </form>
      </div>
      <div class="side-column">
        <div class="side-section">
          <h3>Mood</h3>
          <div>Placeholder to display sentiment analysis by AI.</div>
        </div>
        <div class="side-section">
          <h3>Suggestions</h3>
          <div>Placeholder to display suggestions by AI.</div>
        </div>
        <div class="side-section">
          <h3>Research</h3>
          <div>Placeholder to display research notes and references by AI.</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, reactive } from "vue";
import { useRouter } from "vue-router";

export default defineComponent({
  name: "Submit",
  setup() {
    const router = useRouter();
    const newPost = reactive({
      title: "",
      content: "",
      status: "draft",
    });

    const handleSubmit = async () => {
      try {
        const token = localStorage.getItem("jwt");
        console.log(newPost);
        await fetch("/api/posts", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: JSON.stringify(newPost),
        });
        newPost.title = "";
        newPost.content = "";
        newPost.status = "draft";
        router.push("/");
      } catch (error) {
        console.error(error);
      }
    };

    return {
      newPost,
      handleSubmit,
    };
  },
});
</script>

<style scoped>
.body {
  display: flex;
  justify-content: center;
  margin-top: 2rem;
}
.content-wrapper {
  display: flex;
  gap: 2rem;
  width: 100%;
  max-width: 1000px;
}
.main-content {
  flex: 2;
  background: var(--color-background-card);
  padding: 2rem;
  border-radius: 0.5rem;
  box-shadow: 0 1px 3px var(--shadow-color);
  border: 1px solid var(--color-border);
}
.main-content h1 {
  margin-bottom: 2rem;
  color: var(--color-text);
}
.main-content form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.main-content input,
.main-content textarea,
.main-content select {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 0.375rem;
  font-size: 1rem;
  background-color: var(--color-background);
}
.main-content button {
  background-color: var(--color-primary);
  color: var(--color-text);
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 0.375rem;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}
.main-content button:hover {
  background-color: var(--color-primary-dark);
  transform: translateY(-1px);
}
.side-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}
.side-section {
  background: var(--color-background-card);
  padding: 1rem;
  border-radius: 0.5rem;
  box-shadow: 0 1px 3px var(--shadow-color);
  border: 1px solid var(--color-border);
}
</style>
