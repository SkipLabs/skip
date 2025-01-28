import type { SKDB } from "./skdb.js";
export { SKDBTable, SKDBTransaction } from "./skdb.js";
export type {
  SKDB,
  RemoteSKDB,
  MirrorDefn,
  SKDBGroup,
  Params,
  Creds,
  Environment,
} from "./skdb.js";
export { type DBEnvironment, MuxedSocket } from "./skdb_orchestration.js";
import { createSkdbFor } from "./skdb.js";
import {
  complete as workerComplete,
  WrkImpl,
} from "../skipwasm-worker/browser.js";
import { SKDBWorker } from "./skdb_wdatabase.js";

export async function createSkdb(
  options: {
    dbName?: string;
    asWorker?: boolean;
    disableWarnings?: boolean;
  } = {},
): Promise<SKDB> {
  return await createSkdbFor(workerComplete, createWorker, options);
}

async function createWorker(disableWarnings: boolean, dbName?: string) {
  // important that this line looks exactly like this for bundlers to discover the file
  const wrapped = new Worker(new URL("./skdb_worker.js", import.meta.url), {
    type: "module",
  });
  const worker = new WrkImpl(wrapped);
  const skdb = new SKDBWorker(worker);
  await skdb.create(dbName, disableWarnings);
  return skdb;
}
