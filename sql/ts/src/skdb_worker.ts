import { createOnThisThread } from "./skdb_create.js";
import { onWorkerMessage } from "#std/sk_worker.js";
import type { Creator } from "#std/sk_worker.js";
import type { SKDB } from "./skdb.js";

// @ts-ignore
// prettier-ignore
var modules = [ /*--MODULES--*/];
var extensions = new Map();
/*--EXTENSIONS--*/

class DbCreator implements Creator<SKDB> {
  getName() {
    return "create";
  }

  getType() {
    return "Database";
  }

  async create(dbName?: string) {
    // @ts-ignore
    return createOnThisThread(false, modules, extensions, dbName);
  }
}

const creator = new DbCreator();

var post = (message: any) => {
  postMessage(message);
};

var onMessage = (message: MessageEvent) =>
  onWorkerMessage(message.data, post, creator);

addEventListener("message", onMessage);
