import { createOnThisThread } from "./skdb_create.js";
import type { ModuleInit, EnvInit, EnvCreator } from "../skipwasm-std/index.js";
import type { SKDB } from "./skdb_types.js";
import { SKDBWorker } from "./skdb_wdatabase.js";
export { SKDBTable } from "./skdb_util.js";
export type {
  SKDB,
  RemoteSKDB,
  MirrorDefn,
  SKDBGroup,
  Params,
} from "./skdb_types.js";
export type { Creds, MuxedSocket } from "./skdb_orchestration.js";
export type { Environment } from "../skipwasm-std/index.js";
export { SKDBTransaction } from "./skdb_util.js";

import { init as runtimeInit } from "../skipwasm-std/sk_runtime.js";
import { init as posixInit } from "../skipwasm-std/sk_posix.js";
import { init as skjsonInit } from "../skipwasm-json/skjson.js";
import { init as skdateInit } from "../skipwasm-date/sk_date.js";
import { init as skmonitorInit } from "../skipwasm-monitor/sk_monitor.js";
import { init as skdbInit } from "./skdb_skdb.js";
import { complete as skdbComplete } from "./skdb_env.js";

const modules: ModuleInit[] = [
  runtimeInit,
  posixInit,
  skjsonInit,
  skdateInit,
  skmonitorInit,
  skdbInit,
];

const extensions: EnvInit[] = [skdbComplete];

export async function createSkdbFor(
  skdbComplete: EnvInit,
  createWorker: (
    disableWarnings: boolean,
    dbName?: string,
  ) => Promise<SKDBWorker>,
  createEnvironment: EnvCreator,
  options: {
    dbName?: string;
    asWorker?: boolean;
    disableWarnings?: boolean;
  } = {},
): Promise<SKDB> {
  const disableWarnings = options.disableWarnings ?? false;
  if (!options.asWorker) {
    return createOnThisThread(
      disableWarnings,
      modules,
      [...extensions, skdbComplete],
      createEnvironment,
      options.dbName,
    );
  } else {
    return createWorker(disableWarnings, options.dbName);
  }
}
