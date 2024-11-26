import type { int, ptr, ErrorObject } from "@skip-wasm/std";
import type * as Internal from "./skipruntime_internal_types.js";
import type { Handle } from "./skipruntime_module.js";
import { ServiceInstance } from "./skipruntime_module.js";

export interface FromWasm {
  SkipRuntime_Debug__dirs(): ptr<
    Internal.CJFloat | Internal.CJArray<Internal.CJObject>
  >;
}

type DirList = ({ name: string; isInput: boolean; time: int } & (
  | {
      kind: "eager";
      totalSize: int;
      creator?: { parent: string; child: string; key: string };
    }
  | { kind: "lazy" }
  | { kind: "deleted" }
))[];

export class DebuggingServiceInstance extends ServiceInstance {
  dirs(): DirList {
    const result = this.refs.skjson.runWithGC(() => {
      return this.refs.skjson.importJSON(
        this.refs.fromWasm.SkipRuntime_Debug__dirs(),
      );
    });
    if (typeof result == "number") {
      throw this.refs.handles.deleteAsError(result as Handle<ErrorObject>);
    }
    return result as DirList;
  }
}
