import {
  AbstractEagerCollection,
  AbstractLazyCollection,
  SkipNonUniqueValueError,
  type Context,
  type DepSafe,
  type EagerCollection,
  type Entry,
  type Json,
  type JsonObject,
  type LazyCollection,
  type LazyCompute,
  type Mapper,
  type Reducer,
  type Values,
} from "@skipruntime/core";
import { deepFreeze, SkManaged } from "@skipruntime/core/json.js";
import type { int } from "@skipruntime/core/std.js";
import { spawn } from "child_process";
import * as net from "node:net";
import path from "path";
import type { Logger } from "./logger.js";

export type TestType =
  | "Equal"
  | "EqualUnsorted"
  | "EqualExactly"
  | "NotEqual"
  | "Truthy"
  | "Falsy"
  | "Throws"
  | "NotThrows"
  | "Contains"
  | "NotContains"
  | "GreaterThan"
  | "LessThan"
  | "GreaterThanOrEqual"
  | "LessThanOrEqual"
  | "Match"
  | "NotMatch"
  | "ToBeA"
  | "ToBeRejected"
  | "NotToBeRejected";

export type Compare<T> = {
  readonly type: "Equal" | "NotEqual";
  readonly actual: T;
  readonly expected: T;
};

export type CompareUnsorted<T> = {
  readonly type: "EqualUnsorted";
  readonly actual: T[];
  readonly expected: T[];
};

export type CheckTruthy<T> = {
  readonly type: "Truthy";
  readonly actual: T;
};

export type CheckFalsy<T> = {
  readonly type: "Falsy";
  readonly actual: T;
};

export type CheckThrows = {
  readonly type: "Throws";
  readonly fn: () => void;
  readonly errorType?: new <T>(...args: T[]) => Error;
  readonly errorMessage?: string | RegExp;
};

export type CheckNotThrows = {
  readonly type: "NotThrows";
  readonly fn: () => void;
};

export type CheckToBeRejected = {
  readonly type: "ToBeRejected";
  readonly fn: () => Promise<void>;
  readonly errorType?: new (...args: unknown[]) => Error;
  readonly errorMessage?: string | RegExp;
};

export type CheckNotToBeRejected = {
  readonly type: "NotToBeRejected";
  readonly fn: () => Promise<void>;
};

export type CheckContains<T> = {
  readonly type: "Contains";
  readonly actual: T[];
  readonly expected: T;
};

export type CheckNotContains<T> = {
  readonly type: "NotContains";
  readonly actual: T[];
  readonly expected: T;
};

export type CompareNumeric = {
  readonly type:
    | "GreaterThan"
    | "LessThan"
    | "GreaterThanOrEqual"
    | "LessThanOrEqual";
  readonly actual: number;
  readonly expected: number;
};

export type CheckMatch = {
  readonly type: "Match";
  readonly actual: string;
  readonly pattern: RegExp | string;
};

export type CheckNotMatch = {
  readonly type: "NotMatch";
  readonly actual: string;
  readonly pattern: RegExp | string;
};

export type CheckInstanceOf<T> = {
  readonly type: "ToBeA";
  readonly actual: T;
  readonly cst: new (...args: unknown[]) => T;
};

export type ArrayExpectation<T> =
  | CompareUnsorted<T>
  | CheckContains<T>
  | CheckNotContains<T>;

export type Expectation<T> =
  | Compare<T>
  | CheckTruthy<T>
  | CheckFalsy<T>
  | CheckThrows
  | CheckNotThrows
  | CompareNumeric
  | CheckMatch
  | CheckNotMatch
  | CheckInstanceOf<T>
  | CheckToBeRejected
  | CheckNotToBeRejected;

export type Return<T> = T | Promise<T>;

export type Checkers = {
  value: <T>(e: Expectation<T>) => Promise<void>;
  array: <T>(e: ArrayExpectation<T>) => Promise<void>;
};

export type Test = {
  name: string;
  check: (checkers: Checkers) => Return<void>;
  timeout?: number;
};

export class ArrayValues<T extends Json> implements Values<T> {
  constructor(private values: (T & DepSafe)[]) {}

  getUnique(default_?: { ifMany?: T & DepSafe }): T & DepSafe {
    const first = this.values[0];
    if (
      first === undefined /* i.e. this.materialized.length == 0 */ ||
      this.values.length >= 2
    ) {
      if (default_?.ifMany !== undefined) return default_.ifMany;
      throw new SkipNonUniqueValueError();
    }
    return first;
  }

  toArray(): (T & DepSafe)[] {
    return this.values;
  }

  [Symbol.iterator](): Iterator<T & DepSafe> {
    return this.values[Symbol.iterator]();
  }
}

// Seed map for `ContextTester.useExternalResource` lookups. Keyed by the
// external-source name declared in `extra.externalSources`; the value is the
// list of entries the runtime would have flushed into the collection on a
// successful first tick. Per-identifier / per-params seeding is not modelled
// — the MVP one-source-per-collection convention keeps a single
// (service → entries) map sufficient.
export type ContextTesterExternalResources = {
  readonly [service: string]: readonly Entry<Json, Json>[];
};

export class ContextTester extends SkManaged implements Context {
  // Cached per-service so multiple `useExternalResource` calls inside a
  // single test (e.g. a graph that consumes the same source from two nodes)
  // return the same underlying collection — matches the runtime semantics
  // where one ExternalService subscription backs one EagerCollection.
  private readonly externalResourceCache = new Map<
    string,
    EagerTester<Json, Json>
  >();

  constructor(
    private externalResources?: ContextTesterExternalResources,
    private resources: EagerCollection<
      {
        name: string;
        params: Json;
      },
      number
    > = new EagerTester<
      {
        name: string;
        params: Json;
      },
      number
    >(),
    private logger?: Logger,
  ) {
    super();
  }

  createLazyCollection<
    K extends Json,
    V extends Json,
    Params extends readonly DepSafe[],
  >(
    computeCts: new (...params: Params) => LazyCompute<K, V>,
    ...params: Params
  ): LazyCollection<K, V> {
    return new LazyTester(new computeCts(...params));
  }

  useExternalResource<K extends Json, V extends Json>(resource: {
    service: string;
    identifier: string;
    params?: Json;
  }): EagerCollection<K, V> {
    const cached = this.externalResourceCache.get(resource.service);
    if (cached) {
      // Type-erasure boundary — see the LazyTester precedent above. The
      // seed is provided as `Entry<Json, Json>[]` and the framework
      // contract returns `EagerCollection<K, V>` where K / V are the
      // caller's declared types. Soundness is the test author's
      // responsibility (the seed entries must match the declared types).
      return cached as unknown as EagerCollection<K, V>;
    }
    const entries = this.externalResources?.[resource.service];
    if (entries === undefined) {
      throw new Error(
        `ContextTester.useExternalResource: no seed for external source "${resource.service}". Pass it via the first constructor arg: \`new ContextTester({ ${resource.service}: [<entries>] })\`.`,
      );
    }
    const collection = new EagerTester<Json, Json>();
    for (const [key, values] of entries) {
      collection.setArray(key, values.map(deepFreeze));
    }
    this.externalResourceCache.set(resource.service, collection);
    return collection as unknown as EagerCollection<K, V>;
  }

  jsonExtract(_value: JsonObject, _pattern: string): Json[] {
    throw new Error("Method not implemented.");
  }

  activeResources(): EagerCollection<
    {
      name: string;
      params: Json;
    },
    int
  > {
    return this.resources;
  }

  debug(...args: unknown[]): void {
    this.logger?.debug(...args);
  }

  error(...args: unknown[]): void {
    this.logger?.error(...args);
  }

  warn(...args: unknown[]): void {
    this.logger?.warn(...args);
  }

  info(...args: unknown[]): void {
    this.logger?.info(...args);
  }

  fatal(...args: unknown[]): void {
    this.logger?.fatal(...args);
  }

  trace(...args: unknown[]): void {
    this.logger?.trace(...args);
  }
}

export class LazyTester<K extends Json, V extends Json>
  extends AbstractLazyCollection
  implements LazyCollection<K, V>
{
  private readonly context: Context;

  constructor(private compute: LazyCompute<K, V>) {
    super();
    this.context = new ContextTester();
  }

  getArray(key: K): (V & DepSafe)[] {
    const value = this.compute.compute(this, key, this.context);
    return Array.from(value).map(deepFreeze);
  }

  getUnique(
    key: K,
    default_?: {
      ifNone?: (V & DepSafe) | undefined;
      ifMany?: (V & DepSafe) | undefined;
    },
  ): V & DepSafe {
    const values = this.getArray(key);
    const first = values[0];
    if (
      first === undefined /* i.e. this.materialized.length == 0 */ ||
      values.length >= 2
    ) {
      if (default_?.ifMany !== undefined) return default_.ifMany;
      throw new SkipNonUniqueValueError();
    }
    return first;
  }
}

class DataTester<
  K extends Json,
  V extends Json,
> extends AbstractLazyCollection {
  protected readonly data: Map<string, { key: K; values: (V & DepSafe)[] }> =
    new Map<string, { key: K; values: (V & DepSafe)[] }>();

  set(key: K, value: V & DepSafe) {
    const strKey = this.sortedStringify_(key);
    this.data.set(strKey, { key, values: Array.of(value) });
  }

  setArray(key: K, values: (V & DepSafe)[]) {
    const strKey = this.sortedStringify_(key);
    this.data.set(strKey, { key, values });
  }

  getArray(key: K): (V & DepSafe)[] {
    const strKey = this.sortedStringify_(key);
    let current = this.data.get(strKey);
    if (!current) {
      current = { key, values: Array.of<V & DepSafe>() };
      this.data.set(strKey, current);
    }
    return current.values;
  }

  getUnique(
    key: K,
    default_?: {
      ifNone?: (V & DepSafe) | undefined;
      ifMany?: (V & DepSafe) | undefined;
    },
  ): V & DepSafe {
    const values = this.getArray(key);
    const first = values[0];
    if (
      first === undefined /* i.e. this.materialized.length == 0 */ ||
      values.length >= 2
    ) {
      if (default_?.ifMany !== undefined) return default_.ifMany;
      throw new SkipNonUniqueValueError();
    }
    return first;
  }

  protected sortedStringify_ = (obj: unknown): string => {
    if (obj === null) return "null";
    if (obj === undefined) return "undefined";
    if (typeof obj !== "object") return JSON.stringify(obj);
    if (Array.isArray(obj)) {
      return (
        "[" + obj.map((item) => this.sortedStringify_(item)).join(",") + "]"
      );
    }
    // Plain object: sort keys and recursively stringify
    const keys = Object.keys(obj).sort();
    const pairs = keys.map(
      (key) =>
        JSON.stringify(key) +
        ":" +
        this.sortedStringify_((obj as Record<string, unknown>)[key]),
    );
    return "{" + pairs.join(",") + "}";
  };
}

export class LazyDataTester<K extends Json, V extends Json>
  extends DataTester<K, V>
  implements LazyCollection<K, V> {}

export class EagerTester<K extends Json, V extends Json>
  extends AbstractEagerCollection
  implements EagerCollection<K, V>
{
  protected readonly data: Map<string, { key: K; values: (V & DepSafe)[] }> =
    new Map<string, { key: K; values: (V & DepSafe)[] }>();

  set(key: K, value: V & DepSafe) {
    const strKey = this.sortedStringify_(key);
    this.data.set(strKey, { key, values: Array.of(value) });
  }

  setArray(key: K, values: (V & DepSafe)[]) {
    const strKey = this.sortedStringify_(key);
    this.data.set(strKey, { key, values });
  }

  getArray(key: K): (V & DepSafe)[] {
    const strKey = this.sortedStringify_(key);
    let current = this.data.get(strKey);
    if (!current) {
      current = { key, values: Array.of<V & DepSafe>() };
      this.data.set(strKey, current);
    }
    return current.values;
  }

  getUnique(
    key: K,
    default_?: {
      ifNone?: (V & DepSafe) | undefined;
      ifMany?: (V & DepSafe) | undefined;
    },
  ): V & DepSafe {
    const values = this.getArray(key);
    const first = values[0];
    if (
      first === undefined /* i.e. this.materialized.length == 0 */ ||
      values.length >= 2
    ) {
      if (default_?.ifMany !== undefined) return default_.ifMany;
      throw new SkipNonUniqueValueError();
    }
    return first;
  }

  protected sortedStringify_ = (obj: unknown): string => {
    if (obj === null) return "null";
    if (obj === undefined) return "undefined";
    if (typeof obj !== "object") return JSON.stringify(obj);
    if (Array.isArray(obj)) {
      return (
        "[" + obj.map((item) => this.sortedStringify_(item)).join(",") + "]"
      );
    }
    // Plain object: sort keys and recursively stringify
    const keys = Object.keys(obj).sort();
    const pairs = keys.map(
      (key) =>
        JSON.stringify(key) +
        ":" +
        this.sortedStringify_((obj as Record<string, unknown>)[key]),
    );
    return "{" + pairs.join(",") + "}";
  };

  map<K2 extends Json, V2 extends Json, Params extends readonly DepSafe[]>(
    mapperCst: new (...params: Params) => Mapper<K, V, K2, V2>,
    ...params: Params
  ): EagerCollection<K2, V2> {
    const mapper = new mapperCst(...params);
    const collection = new EagerTester<K2, V2>();
    for (const [_, v] of this.data.entries()) {
      // Skip phantom entries left by getArray when a downstream mapper
      // looked up a missing key — Skip's reactive runtime never
      // surfaces empty-value entries to mappers, and replaying one
      // here trips `values.getUnique()` in the body. keys_(), size()
      // and several other iterators already filter the same way.
      if (v.values.length === 0) continue;
      for (const value of mapper.mapEntry(
        v.key,
        new ArrayValues(v.values),
        new ContextTester(),
      )) {
        const current = collection.getArray(value[0]);
        // Freeze on insertion to mirror the production Skip runtime,
        // which deepFreezes every value pushed into a reactive
        // collection. Without this, mapper bodies that construct
        // outputs via plain object literals (no manual deepFreeze)
        // produce unfrozen values in the test tester, and dataset
        // assertions wrapping `expected` with `deepFreeze(...)` fail
        // on `[Symbol(Skip.managed)]` mismatch even when the field
        // contents match exactly. `reduce` (line above) already
        // applies the same freeze — keeping `map` consistent.
        const dv = deepFreeze(value[1]);
        current.push(dv);
      }
    }
    return collection;
  }

  reduce<Accum extends Json, Params extends readonly DepSafe[]>(
    reducerCst: new (...params: Params) => Reducer<V, Accum>,
    ...params: Params
  ): EagerCollection<K, Accum> {
    const reducer = new reducerCst(...params);
    const collection = new EagerTester<K, Accum>();
    for (const [_, v] of this.data.entries()) {
      if (v.values.length === 0) continue; // phantom entries — see map()
      const computed = v.values.reduce(
        (acc, v) => reducer.add(acc, v),
        reducer.initial,
      )!;
      const freezed: Accum & DepSafe = deepFreeze(computed);
      collection.set(v.key, freezed);
    }
    return collection;
  }

  mapReduce<
    K2 extends Json,
    V2 extends Json,
    MapperParams extends readonly DepSafe[],
  >(
    mapper: new (...params: MapperParams) => Mapper<K, V, K2, V2>,
    ...mapperParams: MapperParams
  ): <Accum extends Json, ReducerParams extends readonly DepSafe[]>(
    reducer: new (...params: ReducerParams) => Reducer<V2, Accum>,
    ...reducerParams: ReducerParams
  ) => EagerCollection<K2, Accum> {
    const mapped = this.map(mapper, ...mapperParams);
    return mapped.reduce.bind(mapped);
  }

  private compare_ = (k1: unknown, k2: unknown): number => {
    // Handle numbers
    if (typeof k1 === "number" && typeof k2 === "number") {
      if (Number.isNaN(k1) && Number.isNaN(k2)) return 0;
      if (Number.isNaN(k1)) return 1;
      if (Number.isNaN(k2)) return -1;
      return k1 - k2;
    }

    // Handle strings
    if (typeof k1 === "string" && typeof k2 === "string")
      return k1.localeCompare(k2);

    // Handle booleans
    if (typeof k1 === "boolean" && typeof k2 === "boolean") {
      return k1 === k2 ? 0 : k1 ? 1 : -1;
    }

    // Handle dates
    if (k1 instanceof Date && k2 instanceof Date) {
      return k1.getTime() - k2.getTime();
    }

    // Handle bigints
    if (typeof k1 === "bigint" && typeof k2 === "bigint") {
      return k1 < k2 ? -1 : k1 > k2 ? 1 : 0;
    }

    // Handle null/undefined
    if (k1 === null && k2 === null) return 0;
    if (k1 === undefined && k2 === undefined) return 0;
    if (k1 === null || k1 === undefined) return -1;
    if (k2 === null || k2 === undefined) return 1;

    // Handle arrays (lexicographic comparison)
    if (Array.isArray(k1) && Array.isArray(k2)) {
      const minLength = Math.min(k1.length, k2.length);
      for (let i = 0; i < minLength; i++) {
        const cmp: number = this.compare_(k1[i], k2[i]);
        if (cmp !== 0) return cmp;
      }
      return k1.length - k2.length;
    }

    // Handle objects with compare method
    if (
      typeof k1 === "object" &&
      "compare" in k1 &&
      typeof k1.compare === "function"
    )
      return (k1.compare as (k: unknown) => number)(k2);

    // Handle plain objects (deep comparison with sorted keys)
    if (typeof k1 === "object" && typeof k2 === "object") {
      try {
        const sortedJson1 = this.sortedStringify_(k1);
        const sortedJson2 = this.sortedStringify_(k2);
        return sortedJson1.localeCompare(sortedJson2);
      } catch {
        // If sortedStringify_ fails, fall through to error
      }
    }

    throw new Error("Unable to compare keys");
  };

  slice(start: K & DepSafe, end: K & DepSafe): EagerCollection<K, V> {
    const compare = this.compare_;
    const keys = this.keys_()
      .sort(compare)
      .filter((v) => compare(v, start) >= 0 && compare(v, end) <= 0);
    const collection = new EagerTester<K, V>();
    for (const k of keys) {
      collection.setArray(k, [...this.getArray(k)]);
    }
    return collection;
  }

  slices(...ranges: [K & DepSafe, K & DepSafe][]): EagerCollection<K, V> {
    const compare = this.compare_;
    const filter = (v: K) => {
      for (const range of ranges) {
        if (compare(v, range[0]) >= 0 && compare(v, range[1]) <= 0) return true;
      }
      return false;
    };
    const keys = this.keys_().sort(compare).filter(filter);
    const collection = new EagerTester<K, V>();
    for (const k of keys) {
      collection.setArray(k, [...this.getArray(k)]);
    }
    return collection;
  }

  take(limit: int): EagerCollection<K, V> {
    const keys = this.keys_().sort(this.compare_).slice(0, limit);
    const collection = new EagerTester<K, V>();
    for (const k of keys) {
      collection.setArray(k, [...this.getArray(k)]);
    }
    return collection;
  }

  merge(...others: EagerCollection<K, V>[]): EagerCollection<K, V> {
    const all = [this, ...others];
    const collection = new EagerTester<K, V>();
    for (const eager of all) {
      if (eager instanceof EagerTester) {
        let k: K;
        let v: (V & DepSafe)[];
        for (const entry of eager.data.values()) {
          if (entry.values.length === 0) continue; // phantom entries — see map()
          k = entry.key;
          v = entry.values;
          const current = collection.getArray(k);
          collection.setArray(k, current.concat(v));
        }
      } else throw new TypeError("Must be EagerTester.");
    }
    return collection;
  }

  size(): number {
    let n = 0;
    for (const entry of this.data.values()) {
      if (entry.values.length > 0) n++;
    }
    return n;
  }

  private keys_(): K[] {
    const keys: K[] = [];
    for (const entry of this.data.values()) {
      if (entry.values.length > 0) keys.push(entry.key);
    }
    return keys;
  }
}

interface Readable {
  on<T extends unknown[]>(event: string, listener: (...args: T) => void): this;
  setEncoding(encoding: string): this;
}

interface ChildProcess {
  stdout: Readable;
  stderr: Readable;
  readonly pid?: number;
  readonly exitCode: number | null;
  kill(signal?: string | number): boolean;
  unref(): void;
  ref(): void;
  on<T extends unknown[]>(event: string, listener: (...args: T) => void): this;
  on(event: "disconnect", listener: () => void): this;
  on(event: "error", listener: (err: Error) => void): this;
  on(
    event: "exit",
    listener: (code: number | null, signal: string | null) => void,
  ): this;
}

export async function waitAndDetach(
  child: ChildProcess,
  test: (stdout: string, stderr: string) => boolean,
  logger?: (...args: unknown[]) => void,
): Promise<() => void> {
  return new Promise((resolve, reject) => {
    let output = "";
    let errors = "";

    // Route chunks through Node's StringDecoder so a UTF-8 codepoint
    // straddling two 'data' events isn't replaced with U+FFFD on each
    // side. The per-chunk String(data) downstream would otherwise tear
    // multi-byte sequences in `output` / `errors`.
    child.stdout.setEncoding("utf8");
    child.stderr.setEncoding("utf8");

    const check = () => {
      if (test(output, errors)) {
        child.unref();

        isResolved = true;
        resolve(() => {
          child.ref();
          if (child.pid !== undefined) {
            try {
              process.kill(-child.pid, "SIGTERM");
            } catch (error) {
              console.error("Failed to kill process group:", error);
              // Fallback to killing just the child process
              child.kill("SIGTERM");
            }
          } else {
            child.kill("SIGTERM");
          }
        });
      }
    };

    child.stderr.on("data", (data) => {
      const message = String(data);
      if (!isResolved) {
        errors += message;
        check();
      }
      if (logger) logger(message);
    });

    child.on("error", reject);

    let hasStarted = false;
    let isResolved = false;
    child.on("spawn", () => {
      hasStarted = true;
    });

    child.on("exit", (code, _signal) => {
      if (isResolved) return;
      if (!hasStarted) {
        reject(new Error(`Process exit before start`));
      } else if (code !== 0 && code !== null) {
        reject(new Error(`Process exit with code ${code}\n${errors}`));
      }
    });

    child.stdout.on("data", (data) => {
      const message = String(data);
      if (!isResolved) {
        output += message;
        check();
      }
      if (logger) logger(message);
    });
  });
}

type Port = {
  readonly port: number;
  readonly close: () => void;
};

class PortPool {
  private inUsePorts: Set<number>;
  private availablePorts: number[];
  private unavailablePorts: Set<number>;

  constructor(
    private minPort: number,
    private maxPort: number,
  ) {
    this.inUsePorts = new Set();
    this.availablePorts = Array.of();
    this.unavailablePorts = new Set();
  }

  async reserve(
    count: number,
  ): Promise<{ ports: number[]; release: () => void }> {
    const available =
      this.maxPort -
      this.minPort -
      this.inUsePorts.size -
      this.unavailablePorts.size;
    if (available < count) {
      throw new Error(
        `Not enough available ports. Need ${count}, have ${available}`,
      );
    }
    const ports: Port[] = Array.of();
    for (let i = 0; i < count; i = i + 1) {
      ports.push(await this.getAvailablePort());
    }

    const portNumbers = ports.map((p) => {
      const portNum = p.port;
      // Mark port as in use before closing the test server
      this.inUsePorts.add(portNum);
      p.close();
      return portNum;
    });

    const release = () => {
      for (const port of portNumbers) {
        this.inUsePorts.delete(port);
        this.availablePorts.push(port);
      }
    };

    return { ports: portNumbers, release };
  }

  private async checkPortAvailability(
    port: number,
  ): Promise<(() => void) | null> {
    if (this.unavailablePorts.has(port)) return null;
    return new Promise((resolve) => {
      const server = net.createServer();
      server.once("error", () => {
        this.unavailablePorts.add(port);
        resolve(null);
      });
      server.once("listening", () => {
        server.close();
        resolve(server.close.bind(server));
      });
      server.listen(port);
    });
  }

  private async getAvailablePort(): Promise<Port> {
    const port = this.availablePorts.pop();
    if (port !== undefined) {
      return {
        port,
        close: () => {
          return;
        },
      };
    }
    const range = this.maxPort - this.minPort - this.inUsePorts.size;
    let attempts = 0;
    const maxAttempts = 100;

    while (attempts < maxAttempts) {
      const randomStart = Math.floor(Math.random() * range);
      const basePort = this.minPort + randomStart;
      if (this.inUsePorts.has(basePort)) continue;
      const close = await this.checkPortAvailability(basePort);
      if (close !== null) {
        return { port: basePort, close };
      }
      attempts = attempts + 1;
    }
    throw new Error(
      `Could not find a port available in range ${this.minPort}-${this.maxPort} after ${maxAttempts} attempts`,
    );
  }
}

export async function availablePortsInRange(
  minPort: number,
  maxPort: number,
  number: number,
): Promise<{
  ports: number[];
  release: () => void;
}> {
  const testPortPool = new PortPool(minPort, maxPort);
  return await testPortPool.reserve(number);
}

export function availablePortRangeGetter(
  minPort: number,
  maxPort: number,
): () => Promise<{
  control_port: number;
  streaming_port: number;
  release: () => void;
}> {
  const testPortPool = new PortPool(minPort, maxPort);
  return async () => {
    const result = await testPortPool.reserve(2);
    const control_port = result.ports[0];
    const streaming_port = result.ports[1];

    if (control_port === undefined || streaming_port === undefined) {
      result.release();
      throw new Error("Failed to allocate 2 ports");
    }
    return {
      control_port,
      streaming_port,
      release: result.release,
    };
  };
}

export async function runSkipRuntimeSuite(
  ports: {
    control_port: number;
    streaming?: { port: number; direct: boolean };
  },
  logger?: (...args: unknown[]) => void,
): Promise<() => void> {
  const env: { [name: string]: string } = {
    ...process.env,
    SKIP_CONTROL_PORT: `${ports.control_port}`,
  };
  if (ports.streaming !== undefined) {
    env["SKIP_STREAMING_PORT"] = `${ports.streaming.port}`;
    env["SKIP_DIRECT_STREAMING"] = ports.streaming.direct.toString();
  }

  const child = spawn("npm", ["run", "start"], {
    detached: true,
    stdio: ["ignore", "pipe", "pipe"],
    env,
  });

  const close = await waitAndDetach(
    child,
    (output, _err) => {
      return (
        (ports.streaming === undefined ||
          output.includes("Streaming listening on port ")) &&
        output.includes("Control listening on port ")
      );
    },
    logger,
  );

  return () => {
    close();
  };
}

export type EntryUpdate<K extends Json, V extends Json> = [
  Entry<K, V>[],
  boolean,
];

export class EntryTestNotifier<K extends Json, V extends Json> {
  private error?: Error;
  private waiting?: () => void;
  private close_?: { readonly close: () => void };

  private constructor(
    private checker: <T>(e: Expectation<T>) => Promise<void>,
    private updates: EntryUpdate<K, V>[] = Array.of(),
  ) {}

  static async make<K extends Json, V extends Json>(
    subscribe: (
      update: (v: () => Entry<K, V>[], init: boolean) => void,
    ) => Promise<{
      readonly close: () => void;
    }>,
    checker: <T>(e: Expectation<T>) => Promise<void>,
    log: boolean = false,
  ): Promise<EntryTestNotifier<K, V>> {
    const notifier = new EntryTestNotifier<K, V>(checker);
    notifier.close_ = await subscribe((getter, init) => {
      try {
        const values = getter();
        if (log) {
          console.log(init ? "INIT" : "UPDATE", JSON.stringify(values));
        }
        notifier.updates.push([values, init]);
      } catch (e: unknown) {
        notifier.error = e instanceof Error ? e : new Error(String(e));
      } finally {
        if (notifier.waiting) {
          notifier.waiting();
          notifier.waiting = undefined;
        }
      }
    });
    return notifier;
  }

  async check(values: Entry<K, V>[], init: boolean) {
    await this.checker({
      type: "NotThrows",
      fn: () => {
        const ex = this.error;
        this.error = undefined;
        if (ex) throw ex;
      },
    });
    await this.checker({
      type: "Equal",
      actual: this.updates.length,
      expected: 1,
    });
    await this.checker({
      type: "Equal",
      actual: this.updates[0]![1],
      expected: init,
    });
    await this.checker({
      type: "Equal",
      actual: this.updates[0]![0],
      expected: values,
    });
    this.updates = Array.of();
  }

  checkInit(values: Entry<K, V>[]) {
    return this.check(values, true);
  }

  checkUpdate(values: Entry<K, V>[]) {
    return this.check(values, false);
  }

  checkEmpty() {
    return {
      type: "Equal",
      actual: this.updates.length,
      expected: 1,
    };
  }

  async wait(timeout: number = 1000) {
    if (this.updates.length > 0) return;
    return new Promise<void>((resolve, reject) => {
      try {
        let rejected = false;
        const timeoutHdl = setTimeout(() => {
          rejected = true;
          reject(new Error("Timeout"));
        }, timeout);
        this.waiting = () => {
          if (rejected) return;
          clearTimeout(timeoutHdl);
          resolve();
        };
      } catch (e: unknown) {
        reject(e instanceof Error ? e : new Error(String(e)));
      }
    });
  }

  close() {
    if (this.close_) this.close_.close();
  }
}

export type DataInit<V extends Json> = V[];
export type DataUpdate<V extends Json> = {
  updated: V[];
  deleted: string[];
};

export class TestNotifier<V extends Json> {
  private error?: Error;
  private waiting?: () => void;
  private close_?: { readonly close: () => void };

  private constructor(
    private checker: <T>(e: Expectation<T>) => Promise<void>,
    private updates: (DataInit<V> | DataUpdate<V>)[] = Array.of(),
  ) {}

  static async make<V extends Json>(
    subscribe: (
      init: (v: DataInit<V>) => void,
      update: (v: DataUpdate<V>) => void,
    ) => Promise<{
      readonly close: () => void;
    }>,
    checker: <T>(e: Expectation<T>) => Promise<void>,
    log: boolean = false,
  ): Promise<TestNotifier<V>> {
    const notifier = new TestNotifier<V>(checker);
    const post = (values: DataInit<V> | DataUpdate<V>, init: boolean) => {
      try {
        if (log) {
          console.log(init ? "INIT" : "UPDATE", JSON.stringify(values));
        }
        notifier.updates.push(values);
      } catch (e: unknown) {
        notifier.error = e instanceof Error ? e : new Error(String(e));
      } finally {
        if (notifier.waiting) {
          notifier.waiting();
          notifier.waiting = undefined;
        }
      }
    };

    notifier.close_ = await subscribe(
      (values) => {
        post(values, true);
      },
      (values) => {
        post(values, false);
      },
    );
    return notifier;
  }

  async check(values: DataInit<V> | DataUpdate<V>) {
    await this.checker({
      type: "NotThrows",
      fn: () => {
        const ex = this.error;
        this.error = undefined;
        if (ex) throw ex;
      },
    });
    await this.checker({
      type: "Equal",
      actual: this.updates.length,
      expected: 1,
    });
    await this.checker({
      type: "Equal",
      actual: this.updates[0],
      expected: values,
    });
    this.updates = Array.of();
  }

  checkInit(values: DataInit<V>) {
    return this.check(values);
  }

  checkUpdate(values: DataUpdate<V>) {
    return this.check(values);
  }

  checkEmpty() {
    return {
      type: "Equal",
      actual: this.updates.length,
      expected: 1,
    };
  }

  async wait(timeout: number = 1000) {
    if (this.updates.length > 0) return;
    return new Promise<void>((resolve, reject) => {
      try {
        let rejected = false;
        const timeoutHdl = setTimeout(() => {
          rejected = true;
          reject(new Error("Timeout"));
        }, timeout);
        this.waiting = () => {
          if (rejected) return;
          clearTimeout(timeoutHdl);
          resolve();
        };
      } catch (e: unknown) {
        reject(e instanceof Error ? e : new Error(String(e)));
      }
    });
  }

  close() {
    if (this.close_) this.close_.close();
  }
}

export type TestInfo = {
  readonly tests: Test[];
  readonly prerequisite?: () => Return<() => Return<void>>;
};

export type CategorizedTests = {
  [categorie: string]: TestInfo;
};

export const packageNameRegex =
  /^(@[a-z0-9-~][a-z0-9-._~]*\/)?[a-z0-9-~][a-z0-9-._~]*$/;

export async function lookupTests(
  servicePackage?: string,
): Promise<CategorizedTests> {
  const testPackage = servicePackage ?? process.env["SKIP_RUNTIME_TESTS"];

  if (!testPackage) throw new Error("SKIP Runtime tests are not defined");

  const testModule = packageNameRegex.test(testPackage)
    ? `${testPackage}/tests.js`
    : path.join(testPackage, "dist/tests/all.test.js");

  const tests_module = await import(testModule);

  if ("tests" in tests_module && typeof tests_module.tests === "function") {
    const tests = tests_module.tests as () => CategorizedTests;

    return tests();
  }
  throw new Error(`Not a valid SKIP service tests definition`);
}
