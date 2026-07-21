import type { Environment } from "../skipwasm-std/index.js";
import type { Wrk, WrkEnvironment } from "./worker.js";

export class WrkImpl implements Wrk {
  constructor(private readonly worker: Worker) {}

  static fromPath(url: URL, options?: WorkerOptions) {
    return new this(new Worker(url, options));
  }

  postMessage = (message: any) => {
    this.worker.postMessage(message);
  };

  onMessage = (listener: (value: any) => void) => {
    this.worker.onmessage = listener;
  };
}

export function complete(env: Environment) {
  const wrkenv = env as WrkEnvironment;
  wrkenv.createWorker = (url: URL, options?: WorkerOptions) =>
    WrkImpl.fromPath(url, options);
  wrkenv.createWorkerWrapper = (worker: Worker) => new WrkImpl(worker);
}
