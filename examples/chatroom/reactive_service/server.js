import { runService } from "@skipruntime/server";
import { service } from "./dist/chatroom.service.js";

runService(service);
