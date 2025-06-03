<template>
  <form @submit.prevent="handleSubmit" class="submit-form">
    <h2>Submit a New Post</h2>
    <div class="form-group">
      <label for="title" class="form-label">Title</label>
      <input
        type="text"
        id="title"
        v-model="title"
        required
        class="form-input"
        placeholder="Enter post title"
      />
    </div>
    <div class="form-group">
      <label for="url" class="form-label">URL</label>
      <input
        type="text"
        id="url"
        v-model="url"
        required
        class="form-input"
        placeholder="Enter post URL"
      />
    </div>
    <div class="form-group">
      <label for="content" class="form-label">Content</label>
      <textarea
        id="content"
        v-model="content"
        required
        class="form-input"
        placeholder="Enter post content"
      ></textarea>
    </div>
    <button type="submit" class="submit-button">Submit Post</button>
  </form>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import { useRouter } from "vue-router";

export default defineComponent({
  name: "Submit",
  setup() {
    const router = useRouter();
    const title = ref("");
    const url = ref("");
    const content = ref("");

    const handleSubmit = async () => {
      try {
        const response = await fetch("/api/posts", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            title: title.value,
            url: url.value,
            content: content.value,
          }),
        });

        if (response.ok) {
          router.push("/");
        } else {
          console.error("Failed to submit post");
        }
      } catch (error) {
        console.error("Error submitting post:", error);
      }
    };

    return {
      title,
      url,
      content,
      handleSubmit,
    };
  },
});
</script>

<style scoped>
.submit-form {
  background-color: var(--color-background-card);
  padding: 2rem;
  border-radius: 0.5rem;
  box-shadow: 0 1px 3px var(--shadow-color);
  border: 1px solid var(--color-border);
}

.submit-form h2 {
  margin-bottom: 2rem;
  color: var(--color-text);
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  color: var(--color-text);
  font-weight: 500;
}

.form-input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid var(--color-border);
  border-radius: 0.375rem;
  font-size: 1rem;
  transition: border-color 0.2s;
  background-color: var(--color-background);
}

.form-input:focus {
  outline: none;
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px var(--color-accent-light);
}

textarea.form-input {
  min-height: 200px;
  resize: vertical;
}

.submit-button {
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

.submit-button:hover {
  background-color: var(--color-primary-dark);
  transform: translateY(-1px);
}
</style>
