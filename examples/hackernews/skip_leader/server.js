import { runService } from "@skipruntime/server";
import { service } from "./dist/hackernews.service.js";

runService(service);
