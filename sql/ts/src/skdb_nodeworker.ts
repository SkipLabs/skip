import { onDbWorkerMessage } from "./skdb_wmessage.js";
import { parentPort } from "worker_threads";

const post = (message: any) => {
  parentPort?.postMessage(message);
};

const onMessage = (message: MessageEvent) => {
  onDbWorkerMessage(message, post);
};

parentPort?.on("message", onMessage);
