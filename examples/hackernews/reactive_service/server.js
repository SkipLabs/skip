import { runService } from "@skipruntime/server";
import { initService } from "@skipruntime/wasm";
import { service } from "./dist/hackernews.service.js";

runService(await initService(service));
