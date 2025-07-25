# Reactive Blogger Frontend

Vue.js 3 frontend for the Reactive Blogger example application, demonstrating real-time updates using Server-Sent Events (SSE) and reactive programming patterns.

## Features

- **Real-time blog feed** - Posts update instantly without page refresh
- **User authentication** - JWT-based login with persistent sessions
- **Post creation** - Rich text editor for creating new blog posts
- **Responsive design** - Works on desktop and mobile devices
- **TypeScript** - Fully typed Vue 3 application with Composition API

## Development Setup

```bash
# Install dependencies
pnpm install

# Development server with hot reload
pnpm run serve

# Build for production
pnpm run build

# Lint and fix files
pnpm run lint
```

## Architecture

### Components

- **`App.vue`** - Main application layout and navigation
- **`Feed.vue`** - Real-time blog post feed using EventSource
- **`Login.vue`** - User authentication form
- **`Submit.vue`** - Post creation and editing form

### Composables

- **`useAuth.ts`** - Authentication state management and JWT handling

### Real-time Updates

The application uses Server-Sent Events (SSE) to receive real-time updates:

```typescript
// EventSource connection to Flask API
const eventSource = new EventSource('/api/posts/stream');
eventSource.onmessage = (event) => {
  const posts = JSON.parse(event.data);
  // Update reactive state
};
```

## Configuration

The application is configured to work with the Docker Compose setup. For local development, ensure the Flask API is running on the expected port.

See [Vue CLI Configuration Reference](https://cli.vuejs.org/config/) for build customization options.
