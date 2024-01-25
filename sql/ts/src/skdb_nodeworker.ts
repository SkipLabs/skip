import { onDbWorkerMessage } from "./skdb_wmessage.js";
import { parentPort } from "worker_threads";

var post = (message: any) => {
  parentPort?.postMessage(message);
};

var onMessage = (message: MessageEvent) => onDbWorkerMessage(message, post);

parentPort?.on("message", onMessage);
