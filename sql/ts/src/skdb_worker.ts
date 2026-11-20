import { type EnvInit, type ModuleInit } from "../skipwasm-std/index.js";
import { createOnThisThread } from "./skdb_create.js";
import { onWorkerMessage, type Creator } from "../skipwasm-worker/worker.js";
import type { SKDB } from "./skdb.js";

import { init as runtimeInit } from "../skipwasm-std/sk_runtime.js";
import { init as posixInit } from "../skipwasm-std/sk_posix.js";
import { init as skjsonInit } from "../skipwasm-json/skjson.js";
import { init as skdateInit } from "../skipwasm-date/sk_date.js";
import { init as skdbInit } from "./skdb_skdb.js";
import { complete as skdbComplete } from "./skdb_env.js";

import { environment as createEnvironment } from "../skipwasm-std/sk_browser.js";

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
    return createOnThisThread(
      false,
      modules,
      extensions,
      createEnvironment,
      dbName,
    );
  }
}

const creator = new DbCreator();

const post = (message: any) => {
  postMessage(message);
};

const onMessage = (message: MessageEvent) => {
  // The worker is only ever created same-origin from the embedding page
  // (browser.ts: new Worker(new URL("./skdb_worker.js", import.meta.url))),
  // so anything else is not a legitimate caller.
  if (message.origin !== self.location.origin) {
    return;
  }
  /* eslint-disable-next-line @typescript-eslint/no-unsafe-argument */
  onWorkerMessage(message.data, post, creator);
};

addEventListener("message", onMessage);
