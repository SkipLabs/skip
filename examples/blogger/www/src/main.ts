import { createApp, type Component } from "vue";
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
// App is imported from a .vue SFC, which typescript-eslint's project service
// resolves as an untyped module, so assert the component type explicitly.
const app = createApp(App as Component);
app.use(router);
app.mount("#app");
