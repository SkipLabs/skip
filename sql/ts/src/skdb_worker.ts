import { type EnvInit, type ModuleInit } from "../skipwasm-std/index.js";
import { createOnThisThread } from "./skdb_create.js";
import { onWorkerMessage, type Creator } from "../skipwasm-std/sk_worker.js";
import type { SKDB } from "./skdb.js";

import { init as runtimeInit } from "../skipwasm-std/sk_runtime.js";
import { init as posixInit } from "../skipwasm-std/sk_posix.js";
import { init as skjsonInit } from "../skipwasm-json/skjson.js";
import { init as skdateInit } from "../skipwasm-date/sk_date.js";
import { init as skdbInit } from "./skdb_skdb.js";
import { complete as skdbComplete } from "./skdb_env.js";

const modules: ModuleInit[] = [
  runtimeInit,
  posixInit,
  skjsonInit,
  skdateInit,
  skdbInit,
];

const extensions: EnvInit[] = [skdbComplete];

class DbCreator implements Creator<SKDB> {
  getName() {
    return "create";
  }

  getType() {
    return "Database";
  }

  async create(dbName?: string) {
    return createOnThisThread(false, modules, extensions, dbName);
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
