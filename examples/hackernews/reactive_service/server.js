import { runService } from "@skipruntime/server";
import { asFollower, asLeader } from "@skipruntime/helpers";
import { service } from "./dist/hackernews.service.js";

if (process.env["SKIP_LEADER"] == "true") {
  console.log("Running as leader...");
  runService(asLeader(service));
} else {
  console.log("Running as follower...");
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
}
