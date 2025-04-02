import { runService, asLeader } from "@skipruntime/server";
import { service } from "./dist/hackernews.service.js";

runService(asLeader(service));
