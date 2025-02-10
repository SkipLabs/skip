import type { Environment } from "../skipwasm-std/index.js";

export interface DBEnvironment extends Environment {
  createSocket: (url: string) => WebSocket;
}

export function complete(env: Environment) {
  const dbenv = env as DBEnvironment;
  dbenv.createSocket = (url: string) => new WebSocket(url);
}
