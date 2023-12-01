import { onDbWorkerMessage } from "#skdb/skdb_wmessage";

var post = (message: any) => {
  postMessage(message);
};

var onMessage = (message: MessageEvent) =>
  onDbWorkerMessage(message.data, post);

addEventListener("message", onMessage);
