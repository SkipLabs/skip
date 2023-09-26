import { onDbWorkerMessage } from "#skdb/skdb_wmessage";
import { parentPort } from "worker_threads";

var post = (message: any) => {
  parentPort?.postMessage(message);
};


var onMessage = (message: MessageEvent) => onDbWorkerMessage(message, post)

parentPort?.on('message', onMessage);