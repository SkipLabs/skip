import { type ModuleInit } from "std";
import { createOnThisThread } from "./skdb_create.js";
import { onWorkerMessage, type Creator } from "std/worker.js";
import type { SKDB } from "./skdb.js";

import { init as runtimeInit } from "std/runtime.js";
import { init as posixInit } from "std/posix.js";
import { init as skjsonInit } from "skjson";
import { init as skdateInit } from "skdate";
import { init as skdbInit } from "./skdb_skdb.js";

const modules: ModuleInit[] = [
  runtimeInit,
  posixInit,
  skjsonInit,
  skdateInit,
  skdbInit,
];

class DbCreator implements Creator<SKDB> {
  getName() {
    return "create";
  }

  getType() {
    return "Database";
  }

  async create(dbName?: string) {
    return createOnThisThread(false, modules, dbName);
  }
}

const creator = new DbCreator();

const post = (message: any) => {
  postMessage(message);
};

const onMessage = (message: MessageEvent) => {
  /* eslint-disable-next-line @typescript-eslint/no-unsafe-argument */
  onWorkerMessage(message.data, post, creator);
};

addEventListener("message", onMessage);
