<template>
  <div class="login-container">
    <div class="login-box">
      <h2 class="login-title">Login</h2>
      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="username" class="form-label">Username</label>
          <input
            type="text"
            id="username"
            v-model="username"
            required
            class="form-input"
            placeholder="Enter your username"
          />
        </div>
        <div class="form-group">
          <label for="password" class="form-label">Password</label>
          <input
            type="password"
            id="password"
            v-model="password"
            required
            class="form-input"
            placeholder="Enter your password"
          />
        </div>
        <button type="submit" class="login-button">Login</button>
        <div v-if="error" class="error-message">{{ error }}</div>
      </form>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from "vue";
import { useRouter } from "vue-router";

export default defineComponent({
  name: "Login",
  setup() {
    const router = useRouter();
    const username = ref("");
    const password = ref("");
    const error = ref("");

    const handleLogin = async () => {
      try {
        const response = await fetch("/api/login", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            username: username.value,
            password: password.value,
          }),
        });

        if (response.ok) {
          router.push("/");
        } else {
          error.value = "Invalid username or password";
        }
      } catch (err) {
        error.value = "An error occurred during login";
        console.error("Login error:", err);
      }
    };

    return {
      username,
      password,
      error,
      handleLogin,
    };
  },
});
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 80vh;
  padding: 20px;
}

.login-box {
  background: var(--color-background-card);
  padding: 2.5rem;
  border-radius: 0.5rem;
  box-shadow: 0 2px 4px var(--shadow-color);
  width: 100%;
  max-width: 360px;
  border: 1px solid var(--color-border);
}

.login-title {
  text-align: center;
  margin-bottom: 2rem;
  color: var(--color-text);
  font-size: 1.75rem;
  font-weight: 600;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-label {
  color: var(--color-text);
  font-weight: 500;
  font-size: 0.95rem;
}

.form-input {
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

.login-button {
  background-color: var(--color-primary);
  color: var(--color-text);
  padding: 0.75rem;
  border: none;
  border-radius: 0.375rem;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.login-button:hover {
  background-color: var(--color-primary-dark);
  transform: translateY(-1px);
}

.error-message {
  color: var(--color-error);
  text-align: center;
  font-size: 0.875rem;
  margin-top: 1rem;
}
</style>
