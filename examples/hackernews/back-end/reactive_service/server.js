import { runService } from "@skipruntime/server";
import HackerNewsService from "./dist/hackernews.service.js";

// Spawn a local HTTP server to support reading/writing and creating
// reactive requests.
runService(new HackerNewsService(), 8080);
