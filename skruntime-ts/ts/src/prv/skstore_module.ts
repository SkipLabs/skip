// prettier-ignore
import type { int, ptr, Links, Utils, ToWasmManager, Environment, Opt, Metadata } from "#std/sk_types.js";
import type { SKJSON } from "./skstore_skjson.js";
import type {
  Accumulator,
  NonEmptyIterator,
  Result,
  AValue,
  LazyCollection,
  TJSON,
} from "../skstore_api.js";

import type {
  Handles,
  Context,
  FromWasm,
  CtxMapping,
} from "./skstore_types.js";
import type * as Internal from "./skstore_internal_types.js";
import { LSelfImpl, SKStoreFactoryImpl } from "./skstore_impl.js";
// prettier-ignore
import type { SKDBShared } from "#skdb/skdb_types.js";

class HandlesImpl implements Handles {
  private nextID: number = 1;
  private objects: any[] = [];
  private freeIDs: int[] = [];
  private env: Environment;

  constructor(env: Environment) {
    this.env = env;
  }

  register(v: JSON) {
    const freeID = this.freeIDs.pop();
    const id = freeID ?? this.nextID++;
    this.objects[id] = v;
    return id;
  }

  get(id: int): any {
    return this.objects[id];
  }

  apply<T>(id: int, parameters: T[]): T {
    const fn = this.objects[id];
    /* eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-return */
    return fn.apply(null, parameters);
  }

  delete(id: int): any {
    const current: unknown = this.objects[id];
    this.objects[id] = null;
    this.freeIDs.push(id);
    return current;
  }

  name = (metadata: Metadata) => {
    return (
      "b64_" +
      this.env.base64Encode(JSON.stringify(metadata)).replaceAll("=", "")
    );
  };
}

export class ContextImpl implements Context {
  skjson: SKJSON;
  exports: FromWasm;
  handles: Handles;
  ref: Ref;

  constructor(skjson: SKJSON, exports: FromWasm, handles: Handles, ref: Ref) {
    this.skjson = skjson;
    this.exports = exports;
    this.handles = handles;
    this.ref = ref;
  }

  noref() {
    return new ContextImpl(this.skjson, this.exports, this.handles, new Ref());
  }

  lazy = <K extends TJSON, V extends TJSON>(
    name: string,
    compute: (self: LazyCollection<K, V>, key: K) => Opt<V>,
  ) => {
    const lazyHdl = this.exports.SKIP_SKStore_lazy(
      this.pointer(),
      this.skjson.exportString(name),
      this.handles.register(compute),
    );
    return this.skjson.importString(lazyHdl);
  };

  asyncLazy = <K extends TJSON, V extends TJSON, P extends TJSON>(
    name: string,
    get: (key: K) => P,
    call: (key: K, params: P) => Promise<V>,
  ) => {
    const lazyHdl = this.exports.SKIP_SKStore_asyncLazy(
      this.pointer(),
      this.skjson.exportString(name),
      this.handles.register(get),
      this.handles.register(call),
    );
    return this.skjson.importString(lazyHdl);
  };

  multimap = <
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
  >(
    name: string,
    mappings: CtxMapping<K1, V1, K2, V2>[],
  ) => {
    const skMappings = mappings.map((mapping) => [
      mapping.source.getId(),
      this.handles.register(mapping.mapper),
    ]);
    const resHdlPtr = this.exports.SKIP_SKStore_multimap(
      this.pointer(),
      this.skjson.exportString(name),
      this.skjson.exportJSON(skMappings),
    );
    return this.skjson.importString(resHdlPtr);
  };

  multimapReduce = <
    K1 extends TJSON,
    V1 extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
  >(
    name: string,
    mappings: CtxMapping<K1, V1, K2, V2>[],
    accumulator: Accumulator<V2, V3>,
  ) => {
    const skMappings = mappings.map((mapping) => [
      mapping.source.getId(),
      this.handles.register(mapping.mapper),
    ]);
    const resHdlPtr = this.exports.SKIP_SKStore_multimapReduce(
      this.pointer(),
      this.skjson.exportString(name),
      this.skjson.exportJSON(skMappings),
      this.handles.register(accumulator),
      this.skjson.exportJSON(accumulator.default),
    );
    return this.skjson.importString(resHdlPtr);
  };

  getFromTable = <K, R>(table: string, key: K, index?: string) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_getFromTable(
        this.pointer(),
        this.skjson.exportString(table),
        this.skjson.exportJSON(key),
        this.skjson.exportJSON(index ?? null),
      ),
    ) as R[];
  };

  getArray = <K, V>(eagerHdl: string, key: K) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_getArray(
        this.pointer(),
        this.skjson.exportString(eagerHdl),
        this.skjson.exportJSON(key),
      ),
    ) as V[];
  };

  getOne = <K, V>(eagerHdl: string, key: K) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_get(
        this.pointer(),
        this.skjson.exportString(eagerHdl),
        this.skjson.exportJSON(key),
      ),
    ) as V;
  };

  maybeGetOne = <K, V>(eagerHdl: string, key: K) => {
    const res = this.exports.SKIP_SKStore_maybeGet(
      this.pointer(),
      this.skjson.exportString(eagerHdl),
      this.skjson.exportJSON(key),
    );
    return this.skjson.importJSON(res) as Opt<V>;
  };

  getArrayLazy = <K, V>(lazyHdl: string, key: K) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_getArrayLazy(
        this.pointer(),
        this.skjson.exportString(lazyHdl),
        this.skjson.exportJSON(key),
      ),
    ) as V[];
  };

  getOneLazy = <K, V>(lazyHdl: string, key: K) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_getLazy(
        this.pointer(),
        this.skjson.exportString(lazyHdl),
        this.skjson.exportJSON(key),
      ),
    ) as V;
  };

  maybeGetOneLazy = <K, V>(lazyHdl: string, key: K) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_maybeGetLazy(
        this.pointer(),
        this.skjson.exportString(lazyHdl),
        this.skjson.exportJSON(key),
      ),
    ) as Opt<V>;
  };

  getArraySelf = <K, V>(lazyHdl: ptr<Internal.LHandle>, key: K) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_getArraySelf(
        this.pointer(),
        lazyHdl,
        this.skjson.exportJSON(key),
      ),
    ) as V[];
  };
  getOneSelf = <K, V>(lazyHdl: ptr<Internal.LHandle>, key: K) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_getSelf(
        this.pointer(),
        lazyHdl,
        this.skjson.exportJSON(key),
      ),
    ) as V;
  };
  maybeGetOneSelf = <K, V>(lazyHdl: ptr<Internal.LHandle>, key: K) => {
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_maybeGetSelf(
        this.pointer(),
        lazyHdl,
        this.skjson.exportJSON(key),
      ),
    ) as Opt<V>;
  };

  size = (eagerHdl: string) => {
    return this.exports.SKIP_SKStore_size(
      this.pointer(),
      this.skjson.exportString(eagerHdl),
    );
  };

  mapReduce = <
    K extends TJSON,
    V extends TJSON,
    K2 extends TJSON,
    V2 extends TJSON,
    V3 extends TJSON,
  >(
    eagerHdl: string,
    name: string,
    mapper: (key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>,
    accumulator: Accumulator<V2, V3>,
  ) => {
    const resHdlPtr = this.exports.SKIP_SKStore_mapReduce(
      this.pointer(),
      this.skjson.exportString(eagerHdl),
      this.skjson.exportString(name),
      this.handles.register(mapper),
      this.handles.register(accumulator),
      this.skjson.exportJSON(accumulator.default),
    );
    return this.skjson.importString(resHdlPtr);
  };

  map = <K extends TJSON, V extends TJSON, K2 extends TJSON, V2 extends TJSON>(
    eagerHdl: string,
    name: string,
    mapper: (key: K, it: NonEmptyIterator<V>) => Iterable<[K2, V2]>,
  ) => {
    const computeFnId = this.handles.register(mapper);
    const resHdlPtr = this.exports.SKIP_SKStore_map(
      this.pointer(),
      this.skjson.exportString(eagerHdl),
      this.skjson.exportString(name),
      computeFnId,
    );
    return this.skjson.importString(resHdlPtr);
  };

  mapFromSkdb = <R extends TJSON, K extends TJSON, V extends TJSON>(
    table: string,
    name: string,
    mapper: (entry: R, occ: number) => Iterable<[K, V]>,
  ) => {
    const computeFnId = this.handles.register(mapper);
    const eagerHdl = this.exports.SKIP_SKStore_fromSkdb(
      this.pointer(),
      this.skjson.exportString(table),
      this.skjson.exportString(name),
      computeFnId,
    );
    return this.skjson.importString(eagerHdl);
  };

  mapToSkdb = <R, K, V>(
    eagerHdl: string,
    table: string,
    convert: (key: K, it: NonEmptyIterator<V>) => R,
  ) => {
    const convertId = this.handles.register(convert);
    this.exports.SKIP_SKStore_toSkdb(
      this.pointer(),
      this.skjson.exportString(eagerHdl),
      this.skjson.exportString(table),
      convertId,
    );
  };

  private pointer = () => {
    return this.ref.get()!;
  };
}

class NonEmptyIteratorImpl<T> implements NonEmptyIterator<T> {
  private skjson: SKJSON;
  private exports: FromWasm;
  private pointer: ptr<Internal.NonEmptyIterator>;

  constructor(
    skjson: SKJSON,
    exports: FromWasm,
    pointer: ptr<Internal.NonEmptyIterator>,
  ) {
    this.skjson = skjson;
    this.exports = exports;
    this.pointer = pointer;
  }

  next(): Opt<T> {
    /* eslint-disable-next-line @typescript-eslint/no-unsafe-return */
    return this.skjson.importOptJSON(
      this.exports.SKIP_SKStore_iteratorNext(this.pointer),
    );
  }

  first(): T {
    /* eslint-disable-next-line @typescript-eslint/no-unsafe-return */
    return this.skjson.importJSON(
      this.exports.SKIP_SKStore_iteratorFirst(this.pointer),
    );
  }

  uniqueValue(): Opt<T> {
    /* eslint-disable-next-line @typescript-eslint/no-unsafe-return */
    return this.skjson.importOptJSON(
      this.exports.SKIP_SKStore_iteratorUniqueValue(this.pointer),
    );
  }

  toArray: () => T[] = () => {
    return Array.from(this);
  };

  [Symbol.iterator](): Iterator<T> {
    const cloned_iter = new NonEmptyIteratorImpl<T>(
      this.skjson,
      this.exports,
      this.exports.SKIP_SKStore_cloneIterator(this.pointer),
    );

    return {
      next() {
        const value = cloned_iter.next();
        return { value, done: value == null } as IteratorResult<T>;
      },
    };
  }
}

class WriterImpl<K, T> {
  private skjson: SKJSON;
  private exports: FromWasm;
  private pointer: ptr<Internal.TWriter>;

  constructor(
    skjson: SKJSON,
    exports: FromWasm,
    pointer: ptr<Internal.TWriter>,
  ) {
    this.skjson = skjson;
    this.exports = exports;
    this.pointer = pointer;
  }

  set = (key: K, value: T) => {
    this.exports.SKIP_SKStore_writerSet(
      this.pointer,
      this.skjson.exportJSON(key),
      this.skjson.exportJSON(value),
    );
  };
  setArray = (key: K, values: T[]) => {
    this.exports.SKIP_SKStore_writerSetArray(
      this.pointer,
      this.skjson.exportJSON(key),
      this.skjson.exportJSON(values),
    );
  };
}

interface ToWasm {
  SKIP_SKStore_detachHandle(fn: int): void;
  // Context
  SKIP_SKStore_applyMapFun(
    fn: int,
    context: ptr<Internal.Context>,
    writer: ptr<Internal.TWriter>,
    key: ptr<Internal.CJSON>,
    it: ptr<Internal.NonEmptyIterator>,
  ): void;
  SKIP_SKStore_applyMapTableFun(
    fn: int,
    context: ptr<Internal.Context>,
    writer: ptr<Internal.TWriter>,
    row: ptr<Internal.CJArray>,
    occ: int,
  ): void;
  SKIP_SKStore_applyConvertToRowFun(
    fn: int,
    key: ptr<Internal.CJSON>,
    it: ptr<Internal.NonEmptyIterator>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_init(context: ptr<Internal.Context>): void;
  SKIP_SKStore_applyLazyFun(
    fn: int,
    context: ptr<Internal.Context>,
    self: ptr<Internal.LHandle>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_applyParamsFun(
    fn: int,
    context: ptr<Internal.Context>,
    key: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_applyLazyAsyncFun(
    fn: int,
    callId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
    param: ptr<Internal.CJSON>,
  ): void;

  // Accumulator
  SKIP_SKStore_applyAccumulate(
    fn: int,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): ptr<Internal.CJSON>;
  SKIP_SKStore_applyDismiss(
    fn: int,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ): Opt<ptr<Internal.CJSON>>;
  // Utils
  SKIP_SKStore_getErrorHdl(exn: ptr<Internal.Exception>): number;
}

class Ref {
  pointers: ptr<Internal.Context>[] = [];

  push(pointer: ptr<Internal.Context>) {
    this.pointers.push(pointer);
  }

  get(): Opt<ptr<Internal.Context>> {
    if (this.pointers.length == 0) return null;
    return this.pointers[this.pointers.length - 1];
  }

  pop(): void {
    this.pointers.pop();
  }
}

class LinksImpl implements Links {
  env: Environment;
  handles: Handles;
  skjson?: SKJSON;

  detachHandle!: (fn: int) => void;
  applyMapFun!: (
    fn: int,
    context: ptr<Internal.Context>,
    writer: ptr<Internal.TWriter>,
    key: ptr<Internal.CJSON>,
    it: ptr<Internal.NonEmptyIterator>,
  ) => void;
  applyMapTableFun!: (
    fn: int,
    context: ptr<Internal.Context>,
    writer: ptr<Internal.TWriter>,
    row: ptr<Internal.CJArray>,
    occ: int,
  ) => void;

  applyLazyFun!: (
    fn: int,
    context: ptr<Internal.Context>,
    self: ptr<Internal.LHandle>,
    key: ptr<Internal.CJSON>,
  ) => ptr<Internal.CJSON>;
  applyParamsFun!: (
    fn: int,
    context: ptr<Internal.Context>,
    key: ptr<Internal.CJSON>,
  ) => ptr<Internal.CJSON>;
  applyLazyAsyncFun!: (
    fn: int,
    callId: ptr<Internal.String>,
    name: ptr<Internal.String>,
    key: ptr<Internal.CJSON>,
    param: ptr<Internal.CJSON>,
  ) => void;
  init!: (context: ptr<Internal.Context>) => void;
  applyAccumulate!: (
    fn: int,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ) => ptr<Internal.CJSON>;
  applyDismiss!: (
    fn: int,
    acc: ptr<Internal.CJSON>,
    value: ptr<Internal.CJSON>,
  ) => Opt<ptr<Internal.CJSON>>;
  getErrorHdl!: (exn: ptr<Internal.Exception>) => number;
  applyConvertToRowFun!: (
    fn: int,
    key: ptr<Internal.CJSON>,
    it: ptr<Internal.NonEmptyIterator>,
  ) => ptr<Internal.CJSON>;

  private initFn!: () => void;

  constructor(env: Environment) {
    this.env = env;
    this.handles = new HandlesImpl(env);
  }

  complete = (utils: Utils, exports: object) => {
    let notify: (() => void) | null = null;
    const fromWasm = exports as FromWasm;
    const skjson = () => {
      if (this.skjson == undefined) {
        this.skjson = this.env.shared.get("SKJSON")! as SKJSON;
      }
      return this.skjson;
    };
    const ref = new Ref();
    this.applyMapFun = (
      fn: int,
      ctx: ptr<Internal.Context>,
      writer: ptr<Internal.TWriter>,
      key: ptr<Internal.CJSON>,
      it: ptr<Internal.NonEmptyIterator>,
    ) => {
      ref.push(ctx);
      const jsu = skjson();
      const w = new WriterImpl(jsu, fromWasm, writer);
      const result = this.handles.apply(fn, [
        jsu.importJSON(key),
        new NonEmptyIteratorImpl(jsu, fromWasm, it),
      ]);
      const bindings = new Map();
      for (const datum of result) {
        const k = datum[0];
        const v = datum[1];
        /* eslint-disable-next-line @typescript-eslint/no-unsafe-call */
        if (bindings.has(k)) bindings.get(k).push(v);
        else bindings.set(k, [v]);
      }
      for (const kv of bindings) {
        /* eslint-disable-next-line @typescript-eslint/no-unsafe-argument */
        w.setArray(kv[0], kv[1]);
      }
      ref.pop();
    };
    this.applyMapTableFun = (
      fn: int,
      ctx: ptr<Internal.Context>,
      writer: ptr<Internal.TWriter>,
      row: ptr<Internal.CJArray>,
      occ: int,
    ) => {
      ref.push(ctx);
      const jsu = skjson();
      const w = new WriterImpl(jsu, fromWasm, writer);
      const result = this.handles.apply(fn, [jsu.importJSON(row), occ]);
      for (const v of result) {
        const t = v as [any, any];
        w.set(t[0], t[1]);
      }
      ref.pop();
    };

    this.applyConvertToRowFun = (
      fn: int,
      key: ptr<Internal.CJSON>,
      it: ptr<Internal.NonEmptyIterator>,
    ) => {
      const jsu = skjson();
      const res = this.handles.apply(fn, [
        jsu.importJSON(key),
        new NonEmptyIteratorImpl(jsu, fromWasm, it),
      ]);
      return jsu.exportJSON(res);
    };

    this.applyLazyAsyncFun = (
      fn: int,
      skcall: ptr<Internal.String>,
      skname: ptr<Internal.String>,
      skkey: ptr<Internal.CJSON>,
      skparams: ptr<Internal.CJSON>,
    ) => {
      const jsu = skjson();
      const callId = jsu.importString(skcall);
      const name = jsu.importString(skname);
      const key = jsu.importJSON(skkey, true);
      const params = jsu.importJSON(skparams, true);
      /* eslint-disable-next-line @typescript-eslint/no-unsafe-argument */
      const promise = this.handles.apply<Promise<AValue<TJSON, TJSON>>>(fn, [
        key,
        params,
      ]);
      const register = (value: Result<TJSON, TJSON>) => {
        if (!notify) {
          const skdbApp = this.env.shared.get("SKDB") as SKDBShared;
          notify = skdbApp.notify;
        }
        setTimeout(() => {
          const result = jsu.runWithGC(() => {
            return Math.trunc(
              fromWasm.SKIP_SKStore_asyncResult(
                jsu.exportString(callId),
                jsu.exportString(name),
                jsu.exportJSON(key),
                jsu.exportJSON(params),
                jsu.exportJSON(value),
              ),
            );
          });
          if (result < 0) {
            throw this.handles.delete(-result);
          } else if (notify) {
            notify();
          }
        }, 0);
      };
      promise
        .then((value) => {
          if (value.payload !== undefined) {
            register(
              value.metadata !== undefined
                ? {
                    status: "success",
                    payload: value.payload,
                    metadata: value.metadata,
                  }
                : {
                    status: "success",
                    payload: value.payload,
                  },
            );
          } else {
            register(
              value.metadata !== undefined
                ? {
                    status: "unchanged",
                    metadata: value.metadata,
                  }
                : {
                    status: "unchanged",
                  },
            );
          }
        })
        .catch((reason: unknown) => {
          let msg: string;
          if (reason instanceof Error) {
            msg = reason.message;
          } else if (typeof reason == "string") {
            msg = reason;
          } else {
            msg = JSON.stringify(reason);
          }
          register({ status: "failure", error: msg });
        });
    };

    this.applyLazyFun = (
      fn: int,
      ctx: ptr<Internal.Context>,
      hdl: ptr<Internal.LHandle>,
      key: ptr<Internal.CJSON>,
    ) => {
      ref.push(ctx);
      const jsu = skjson();
      const context = new ContextImpl(jsu, fromWasm, this.handles, ref);
      const res = jsu.exportJSON(
        this.handles.apply(fn, [
          new LSelfImpl(context, hdl),
          jsu.importJSON(key),
        ]),
      );
      ref.pop();
      return res;
    };

    this.applyParamsFun = (
      fn: int,
      ctx: ptr<Internal.Context>,
      key: ptr<Internal.CJSON>,
    ) => {
      ref.push(ctx);
      const jsu = skjson();
      const res = jsu.exportJSON(this.handles.apply(fn, [jsu.importJSON(key)]));
      ref.pop();
      return res;
    };
    this.init = (context: ptr<Internal.Context>) => {
      ref.push(context);
      this.initFn();
      ref.pop();
    };
    this.applyAccumulate = (
      fn: int,
      acc: ptr<Internal.CJSON>,
      value: ptr<Internal.CJSON>,
    ) => {
      const jsu = skjson();
      const accumulator = this.handles.get(fn) as Accumulator<any, any>;
      const result = accumulator.accumulate(
        jsu.importJSON(acc),
        jsu.importJSON(value),
      );
      return jsu.exportJSON(result);
    };
    this.applyDismiss = (
      fn: int,
      acc: ptr<Internal.CJSON>,
      value: ptr<Internal.CJSON>,
    ) => {
      const jsu = skjson();
      const accumulator = this.handles.get(fn) as Accumulator<any, any>;
      const result = accumulator.dismiss(
        jsu.importJSON(acc),
        jsu.importJSON(value),
      );
      return result != null ? jsu.exportJSON(result) : null;
    };
    this.detachHandle = (idx: int) => {
      this.handles.delete(idx);
    };
    this.getErrorHdl = (exn: ptr<Internal.Exception>) => {
      return this.handles.register(utils.getErrorObject(exn));
    };
    const create = (init: () => void) => {
      // Register the init function to have  a named init function
      this.initFn = init;
      // Get a run uuid to build to allow function mapping reload in case of persistence
      const uuid = this.env.crypto().randomUUID();
      const jsu = skjson();
      const result = utils.runWithGc(() =>
        Math.trunc(fromWasm.SKIP_SKStore_createFor(jsu.exportString(uuid))),
      );
      if (result < 0) {
        throw this.handles.delete(-result);
      }
    };
    this.env.shared.set(
      "SKStore",
      new SKStoreFactoryImpl(
        () => new ContextImpl(skjson(), fromWasm, this.handles, ref),
        create,
        (dbName, asWorker) =>
          (this.env.shared.get("SKDB") as SKDBShared).createSync(
            dbName,
            asWorker,
          ),
      ),
    );
  };
}

class Manager implements ToWasmManager {
  env: Environment;

  constructor(env: Environment) {
    this.env = env;
  }

  prepare = (wasm: object) => {
    const toWasm = wasm as ToWasm;
    const links = new LinksImpl(this.env);
    toWasm.SKIP_SKStore_detachHandle = (fn: int) => {
      links.detachHandle(fn);
    };
    toWasm.SKIP_SKStore_applyMapFun = (
      fn: int,
      context: ptr<Internal.Context>,
      writer: ptr<Internal.TWriter>,
      key: ptr<Internal.CJSON>,
      it: ptr<Internal.NonEmptyIterator>,
    ) => {
      links.applyMapFun(fn, context, writer, key, it);
    };
    toWasm.SKIP_SKStore_applyMapTableFun = (
      fn: int,
      context: ptr<Internal.Context>,
      writer: ptr<Internal.TWriter>,
      row: ptr<Internal.CJArray>,
      occ: int,
    ) => {
      links.applyMapTableFun(fn, context, writer, row, occ);
    };
    toWasm.SKIP_SKStore_applyConvertToRowFun = (
      fn: int,
      key: ptr<Internal.CJSON>,
      it: ptr<Internal.NonEmptyIterator>,
    ) => links.applyConvertToRowFun(fn, key, it);
    toWasm.SKIP_SKStore_init = (context: ptr<Internal.Context>) => {
      links.init(context);
    };
    toWasm.SKIP_SKStore_applyLazyFun = (fn, context, self, key) =>
      links.applyLazyFun(fn, context, self, key);

    toWasm.SKIP_SKStore_applyParamsFun = (fn, context, key) =>
      links.applyParamsFun(fn, context, key);
    toWasm.SKIP_SKStore_applyLazyAsyncFun = (
      fn: int,
      call: ptr<Internal.String>,
      name: ptr<Internal.String>,
      key: ptr<Internal.CJSON>,
      param: ptr<Internal.CJSON>,
    ) => {
      links.applyLazyAsyncFun(fn, call, name, key, param);
    };
    toWasm.SKIP_SKStore_applyAccumulate = (
      fn: int,
      acc: ptr<Internal.CJSON>,
      value: ptr<Internal.CJSON>,
    ) => links.applyAccumulate(fn, acc, value);
    toWasm.SKIP_SKStore_applyDismiss = (
      fn: int,
      acc: ptr<Internal.CJSON>,
      value: ptr<Internal.CJSON>,
    ) => links.applyDismiss(fn, acc, value);
    toWasm.SKIP_SKStore_getErrorHdl = (exn: ptr<Internal.Exception>) =>
      links.getErrorHdl(exn);
    return links;
  };
}

/* @sk init */
export function init(env: Environment) {
  return Promise.resolve(new Manager(env));
}
