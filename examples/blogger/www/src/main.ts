import { createApp } from "vue";
import { createRouter, createWebHistory } from "vue-router";
import App from "./App.vue";

// Create router instance
const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: "/",
      component: () => import("./components/Feed.vue"),
    },
    {
      path: "/submit",
      component: () => import("./components/Submit.vue"),
    },
    {
      path: "/login",
      component: () => import("./components/Login.vue"),
    },
  ],
});

// Create and mount the app
const app = createApp(App);
app.use(router);
app.mount("#app");
