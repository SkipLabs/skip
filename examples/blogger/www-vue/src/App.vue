<template>
  <div class="app">
    <header class="header">
      <img src="./assets/logo.png" alt="Logo" class="logo" />
      <div class="title">Blogger</div>
      <nav class="menu">
        <router-link to="/">Home</router-link>
        <router-link to="/submit">Submit</router-link>
      </nav>
      <div class="login">
        <router-link to="/login">
          <button>Login</button>
        </router-link>
      </div>
    </header>

    <main class="body">
      <router-view></router-view>
    </main>
  </div>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  name: "App",
});
</script>

<style>
/* Color Palette */
:root {
  /* Primary Colors */
  --color-primary: #e6f3ff; /* Light Sky Blue */
  --color-primary-light: #f5f9ff; /* Ice Blue */
  --color-primary-dark: #b8d9f0; /* Soft Blue */

  /* Accent Colors */
  --color-accent: #d4e6f7; /* Powder Blue */
  --color-accent-light: #f0f7ff; /* Lightest Blue */

  /* Text Colors */
  --color-text: #2c3e50; /* Dark Slate Blue */
  --color-text-light: #7f8c8d; /* Medium Gray */

  /* Background Colors */
  --color-background: #ffffff; /* Pure White */
  --color-background-card: #f8fafc; /* Snow White */

  /* Border Colors */
  --color-border: #e2e8f0; /* Light Gray */

  /* Error Colors */
  --color-error: #e6f3ff; /* Light Sky Blue */

  /* Shadow Colors */
  --shadow-color: rgba(44, 62, 80, 0.05);
}

/* Base Styles */
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen,
    Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
  color: var(--color-text);
  line-height: 1.6;
  background-color: var(--color-background);
}

/* Header Styles */
.header {
  background-color: var(--color-primary);
  padding: 1rem 2rem;
  display: flex;
  align-items: center;
  gap: 2rem;
  color: var(--color-text);
  box-shadow: 0 2px 4px var(--shadow-color);
}

.header img {
  filter: brightness(0) invert(0);
}

.title {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--color-text);
}

.menu {
  flex-grow: 1;
}

.menu a {
  color: var(--color-text);
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  transition: all 0.2s;
}

.menu a:hover {
  background-color: var(--color-primary-light);
  color: var(--color-text);
}

.login button {
  background-color: var(--color-primary-light);
  color: var(--color-text);
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.login button:hover {
  background-color: var(--color-primary-dark);
  color: var(--color-text);
}

/* Body and Content Styles */
.body {
  max-width: 800px;
  margin: 2rem auto;
  padding: 0 1rem;
}

.logo {
  height: 2rem;
  transition: transform 0.3s ease;
}

.logo:hover {
  transform: rotate(180deg);
}
</style>
