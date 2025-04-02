import { runService, asFollower } from "@skipruntime/server";
import { service } from "./dist/hackernews.service.js";

runService(
  asFollower(service, {
    leader: {
      host: "skip_leader",
      streaming_port: 8080,
      control_port: 8081,
    },
    collections: ["postsWithUpvotes", "sessions"],
  }),
);
