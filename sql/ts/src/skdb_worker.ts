import { onDbWorkerMessage } from "./skdb_wmessage.js";

var post = (message: any) => {
  postMessage(message);
};

var onMessage = (message: MessageEvent) =>
  onDbWorkerMessage(message.data, post);

addEventListener("message", onMessage);
