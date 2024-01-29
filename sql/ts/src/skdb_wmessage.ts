import { onWorkerMessage } from "#std/sk_worker.js";
import type { Creator } from "#std/sk_worker.js";
import type { SKDB } from "./skdb.js";
import { createSkdb } from "./skdb.js";

class DbCreator implements Creator<SKDB> {
  getName() {
    return "create";
  }

  getType() {
    return "Database";
  }

  create(dnName: string) {
    return createSkdb({
      dbName: dnName,
      asWorker: false,
    });
  }
}

const creator = new DbCreator();

export const onDbWorkerMessage = (
  message: MessageEvent,
  post: (message: any) => void,
) => {
  onWorkerMessage(message, post, creator);
};
