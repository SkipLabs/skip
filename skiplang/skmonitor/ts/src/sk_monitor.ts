import type * as Internal from "../skiplang-std/internal.js";
import type {
  int,
  ptr,
  float,
  Environment,
  Links,
  ToWasmManager,
  Utils,
  Nullable,
} from "../skipwasm-std/index.js";

interface ToWasm {
  SKIP_SKMonitor_write: (content: ptr<Internal.String>) => void;
  SKIP_SKMonitor_traceIdOpt: () => Nullable<ptr<Internal.String>>;
  SKIP_SKMonitor_monitoringOpt: () => Nullable<ptr<Internal.String>>;
  SKIP_JS_now: () => float;
}

class LinksImpl implements Links {
  write!: (content: ptr<Internal.String>) => int;
  traceIdOpt!: () => Nullable<ptr<Internal.String>>;
  monitoringOpt!: () => Nullable<ptr<Internal.String>>;

  complete = (utils: Utils, _exports: object) => {
    this.write = (content: ptr<Internal.String>) => {
      console.log(utils.importString(content));
      return 1;
    };
    this.traceIdOpt = () => {
      return null;
    };
    this.monitoringOpt = () => {
      return null;
    };
  };
}

class Manager implements ToWasmManager {
  prepare = (wasm: object) => {
    const toWasm = wasm as ToWasm;
    const links = new LinksImpl();
    toWasm.SKIP_SKMonitor_write = (content: ptr<Internal.String>) =>
      links.write(content);
    toWasm.SKIP_SKMonitor_traceIdOpt = () => links.traceIdOpt();
    toWasm.SKIP_SKMonitor_monitoringOpt = () => links.monitoringOpt();
    toWasm.SKIP_JS_now = () => Date.now() / 1000;
    return links;
  };
}

/* @sk init */
/**
 * Init the Monitoring Wasm code manager according given environment
 * @param _env The current environnement
 * @returns The Monitoring Wasm code manager
 */
export function init(_env?: Environment) {
  return Promise.resolve(new Manager());
}
