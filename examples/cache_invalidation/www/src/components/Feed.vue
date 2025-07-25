<template>
  <div class="feed">
    <div v-for="post in posts" :key="post.id" class="post">
      <a
        :href="post.url"
        class="posttitle"
        target="_blank"
        rel="noopener noreferrer"
      >
        {{ post.title }}
      </a>
      <span class="status">{{ post.status }}</span>
      <div class="content">{{ post.content }}</div>
      <div class="subtext">
        Posted by {{ post.author }} on
        {{ new Date(post.created_at).toLocaleDateString() }}
      </div>
    </div>
  </div>
</template>

<script lang="ts">
/**
 * Feed Component - Real-time Display of Automated Cache Invalidation
 * 
 * This component demonstrates Skip's automated cache invalidation in action:
 * - Uses EventSource (SSE) to receive real-time updates from the cache
 * - When database changes occur, cache automatically invalidates
 * - Updates flow to this component with minimal delay (eventual consistency)
 * - No manual refresh needed - cache updates propagate automatically
 */
import { defineComponent, ref, onMounted } from "vue";

interface Post {
  id: number;
  title: string;
  content: string;
  url: string;
  status: string;
  author: string;
  created_at: string;
}

export default defineComponent({
  name: "Feed",
  setup() {
    const posts = ref<Post[]>([]);

    onMounted(() => {
      // EventSource receives automatic updates when cache is invalidated
      const evSource = new EventSource("/api/posts");

      // Initial data load from cache
      evSource.addEventListener("init", (e: Event) => {
        const data = JSON.parse((e as MessageEvent<string>).data) as [
          number,
          any[],
        ][];
        posts.value = data.map(([post_id, values]) => ({
          ...values[0],
          id: post_id,
        })) as Post[];
      });

      // Real-time updates triggered by automatic cache invalidation
      // When someone creates/updates/deletes a post in the database:
      // 1. Skip detects the database change automatically
      // 2. Cache entries are invalidated without manual intervention
      // 3. This update event fires with the fresh data
      evSource.addEventListener("update", (e: Event) => {
        const data = JSON.parse((e as MessageEvent<string>).data);
        const modifiedPosts: number[] = [];
        const updatedPosts: Post[] = [];

        for (const [post_id, values] of data) {
          modifiedPosts.push(post_id);
          if (values.length > 0) {
            updatedPosts.push({ ...values[0], id: post_id });
          }
        }

        // Merge updates with existing posts - deleted posts are automatically removed
        posts.value = updatedPosts.concat(
          posts.value.filter((post) => !modifiedPosts.includes(post.id)),
        );
      });

      return () => {
        evSource.close();
      };
    });

    return {
      posts,
    };
  },
});
</script>

<style scoped>
.post {
  background-color: var(--color-background-card);
  border-radius: 0.5rem;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  box-shadow: 0 1px 3px var(--shadow-color);
  transition: transform 0.2s;
  border: 1px solid var(--color-border);
}

.post:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px var(--shadow-color);
}

.posttitle {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--color-text);
  margin-bottom: 0.5rem;
  display: block;
  text-decoration: none;
}

.posttitle:hover {
  color: var(--color-primary-dark);
}

.status {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  font-size: 0.875rem;
  font-weight: 500;
  margin-left: 1rem;
  background-color: var(--color-accent);
  color: var(--color-text);
}

.content {
  color: var(--color-text);
  margin: 1rem 0;
  white-space: pre-wrap;
}

.subtext {
  color: var(--color-text-light);
  font-size: 0.875rem;
  margin-top: 1rem;
}
</style>
