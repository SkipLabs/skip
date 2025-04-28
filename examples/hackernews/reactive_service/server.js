import { runService } from "@skipruntime/server";
import { asFollower, asLeader } from "@skipruntime/helpers";
import { service } from "./dist/hackernews.service.js";

if (process.env["SKIP_LEADER"] == "true") {
  console.log("Running as leader...");
  await runService(asLeader(service)).catch(console.error);
} else if (process.env["SKIP_FOLLOWER"] == "true") {
  console.log("Running as follower...");
  await runService(
    asFollower(service, {
      leader: {
        host: process.env["SKIP_LEADER_HOST"] || "skip_leader",
        streaming_port: 8080,
        control_port: 8081,
      },
      collections: ["postsWithUpvotes", "sessions"],
    }),
  ).catch(console.error);
} else {
  console.log("Running non-distributed...");
  await runService(service).catch(console.error);
}
