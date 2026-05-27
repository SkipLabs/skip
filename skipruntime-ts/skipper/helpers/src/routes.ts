import type {
  CollectionUpdate,
  Entry,
  Json,
  JsonObject,
  ServiceInstance,
} from "@skipruntime/core";
import { EventSource } from "eventsource";
import {
  expectArrayWith,
  expectEntriesWith,
  expectString,
  message,
} from "./check.js";
import type { Return } from "./tests.js";

export type { Json, JsonObject };

export class CodeError extends Error {
  constructor(
    public code: number,
    public error: string,
    public contentType?: string,
  ) {
    super(`Error ${code}: ${error}`);
  }
}

// Without body
export const GET: Method = "GET";
export const HEAD: Method = "HEAD";
export const OPTIONS: Method = "OPTIONS";
export const TRACE: Method = "TRACE";
export const DELETE: Method = "DELETE";
export const CONNECT: Method = "CONNECT";

// With body
export const PUT: Method = "PUT";
export const POST: Method = "POST";
export const PATCH: Method = "PATCH";

export type WithoutBody =
  | "GET"
  | "HEAD"
  | "OPTIONS"
  | "TRACE"
  | "DELETE"
  | "CONNECT";
export type WithBody = "PUT" | "POST" | "PATCH";

export type Method = WithoutBody | WithBody;

export type CacheControl = {
  maxAge?: number; // seconds
  sMaxAge?: number; // shared cache max age in seconds
  private?: boolean;
  public?: boolean;
  noCache?: boolean;
  noStore?: boolean;
  mustRevalidate?: boolean;
  proxyRevalidate?: boolean;
  immutable?: boolean;
  staleWhileRevalidate?: number; // seconds
  staleIfError?: number; // seconds
};

export function buildCacheControlHeader(cache: CacheControl): string {
  const parts: string[] = [];

  if (cache.maxAge !== undefined) parts.push(`max-age=${cache.maxAge}`);
  if (cache.sMaxAge !== undefined) parts.push(`s-maxage=${cache.sMaxAge}`);
  if (cache.private) parts.push("private");
  if (cache.public) parts.push("public");
  if (cache.noCache) parts.push("no-cache");
  if (cache.noStore) parts.push("no-store");
  if (cache.mustRevalidate) parts.push("must-revalidate");
  if (cache.proxyRevalidate) parts.push("proxy-revalidate");
  if (cache.immutable) parts.push("immutable");
  if (cache.staleWhileRevalidate !== undefined)
    parts.push(`stale-while-revalidate=${cache.staleWhileRevalidate}`);
  if (cache.staleIfError !== undefined)
    parts.push(`stale-if-error=${cache.staleIfError}`);

  return parts.join(", ");
}

export function checkCache<T extends Json | undefined>(
  headers: {
    [name: string]: string;
  },
  response: SkipResponse<T>,
): SkipResponse<T> {
  // Helper to normalize ETags (handle W/ prefix for weak ETags)
  const normalizeEtag = (etag: string) => etag.replace(/^W\//, "");

  // If-Match: For PUT/PATCH/DELETE - check resource hasn't changed
  const ifMatch = headers["if-match"];
  if (ifMatch && response.etag) {
    // Support wildcard * (match any existing resource)
    if (
      ifMatch !== "*" &&
      normalizeEtag(ifMatch) !== normalizeEtag(response.etag)
    ) {
      // Precondition failed: resource has changed
      return new SkipResponse(
        412,
        undefined as T,
        response.headers,
        response.etag,
        response.lastModified,
        response.contentType,
      );
    }
  }

  // If-Unmodified-Since: Date fallback for PUT/PATCH/DELETE
  const ifUnmodifiedSince = headers["if-unmodified-since"];
  if (ifUnmodifiedSince && !ifMatch && response.lastModified) {
    const clientDate = new Date(ifUnmodifiedSince);
    const serverTime = Math.floor(response.lastModified.getTime() / 1000);
    const clientTime = Math.floor(clientDate.getTime() / 1000);

    if (serverTime > clientTime) {
      // Precondition failed: resource was modified
      return new SkipResponse(
        412,
        undefined as T,
        response.headers,
        response.etag,
        response.lastModified,
        response.contentType,
      );
    }
  }

  // If-None-Match: For GET - cache validation
  const ifNoneMatch = headers["if-none-match"];
  if (ifNoneMatch && response.etag) {
    // Support wildcard *
    if (
      ifNoneMatch === "*" ||
      normalizeEtag(ifNoneMatch) === normalizeEtag(response.etag)
    ) {
      return new SkipResponse(
        304,
        undefined as T,
        response.headers,
        response.etag,
        response.lastModified,
        response.contentType,
      );
    }
  }

  // If-Modified-Since: Date fallback for GET
  const ifModifiedSince = headers["if-modified-since"];
  if (ifModifiedSince && !ifNoneMatch && response.lastModified) {
    const clientDate = new Date(ifModifiedSince);
    const serverTime = Math.floor(response.lastModified.getTime() / 1000);
    const clientTime = Math.floor(clientDate.getTime() / 1000);

    if (serverTime <= clientTime) {
      return new SkipResponse(
        304,
        undefined as T,
        response.headers,
        response.etag,
        response.lastModified,
        response.contentType,
      );
    }
  }

  return response;
}

export interface Command {
  readonly method: Method;
  readonly path: string;
  readonly accepted?: string[];
  readonly cache?: CacheControl;
}

export class SkipResponse<T = undefined> {
  constructor(
    public status: number,
    public body: T,
    public headers?: { [name: string]: string },
    public etag?: string,
    public lastModified?: Date,
    public contentType?: string,
  ) {}
}

export class SkipRedirect {
  constructor(
    public code: number,
    public url: string,
  ) {}
}

export type StreamData = { event: string; id: string; data: string };

export interface SkipStream {
  write(data: StreamData): void;
  close(): void;
}

export class StreamerResult {
  constructor(public close: () => Return<void>) {}
}

export interface SkipStreamer {
  stream(
    stream: SkipStream,
    onInit: (status: number) => void,
  ): Return<StreamerResult>;
}

export type SkipResult<T = undefined> =
  | SkipResponse<T>
  | SkipRedirect
  | SkipStreamer;

export type HttpHeaders = { [name: string]: string | string[] | undefined };

export type Route<R> = {
  readonly perform: (
    params: unknown,
    body: unknown,
    query: unknown,
    headers: HttpHeaders,
  ) => Promise<SkipResult<R>>;
  readonly method: Method;
  readonly path: string;
  readonly accepted?: string[];
  readonly cache?: CacheControl;
};

export type CorsConfig = {
  // Origins allowed to make requests
  allowOrigins?: string[] | "*" | ((origin: string) => boolean);
  // HTTP methods allowed
  allowMethods?: Method[] | "*";
  // Headers allowed in requests
  allowHeaders?: string[] | "*";
  // Headers exposed to the client
  exposeHeaders?: string[];
  // Allow credentials (cookies, authorization headers)
  allowCredentials?: boolean;
  // Preflight cache duration in seconds
  maxAge?: number;
};

export function configCors(
  cors: CorsConfig,
  headers: (name: string, value: string) => void,
  origin?: string,
): void {
  // Access-Control-Allow-Origin
  if (cors.allowOrigins) {
    if (cors.allowOrigins === "*") {
      headers("Access-Control-Allow-Origin", "*");
    } else if (Array.isArray(cors.allowOrigins)) {
      headers("Access-Control-Allow-Origin", cors.allowOrigins.join(", "));
    } else if (typeof cors.allowOrigins === "function") {
      // Function type: check if the origin is allowed
      if (origin && cors.allowOrigins(origin)) {
        headers("Access-Control-Allow-Origin", origin);
        headers("Vary", "Origin");
      }
    }
  }

  // Access-Control-Allow-Methods
  if (cors.allowMethods) {
    if (cors.allowMethods === "*") {
      headers("Access-Control-Allow-Methods", "*");
    } else {
      headers("Access-Control-Allow-Methods", cors.allowMethods.join(", "));
    }
  }

  // Access-Control-Allow-Headers
  if (cors.allowHeaders) {
    if (cors.allowHeaders === "*") {
      headers("Access-Control-Allow-Headers", "*");
    } else {
      headers("Access-Control-Allow-Headers", cors.allowHeaders.join(", "));
    }
  }

  // Access-Control-Expose-Headers
  if (cors.exposeHeaders && cors.exposeHeaders.length > 0) {
    headers("Access-Control-Expose-Headers", cors.exposeHeaders.join(", "));
  }

  // Access-Control-Allow-Credentials
  if (cors.allowCredentials) {
    headers("Access-Control-Allow-Credentials", "true");
  }

  // Access-Control-Max-Age
  if (cors.maxAge !== undefined) {
    headers("Access-Control-Max-Age", cors.maxAge.toString());
  }
}

export type RestServiceOptions = {
  readonly port?: number;
  readonly cors?: () => CorsConfig | false; // false = disable CORS, undefined = default permissive
  readonly healthcheck?: string;
  readonly openapiJson?: string;
  readonly indexHtml?: string;
  readonly htmlPages?: { readonly [path: string]: string };
  readonly googleClientId?: string | null;
};

export type RestService = {
  readonly commands: Command[];
  readonly options?: RestServiceOptions;
};

export function manageEntriesStream<K extends Json, V extends Json>(
  url: string,
  update: (v: () => Entry<K, V>[], init: boolean) => void,
  keyChecker: (v: unknown, path: string) => K,
  valueChecker: (v: unknown, path: string) => V,
): Promise<{
  readonly close: () => void;
}> {
  let resolved = false;
  return new Promise((resolve, reject) => {
    const evSource = new EventSource(url);
    evSource.addEventListener("open", () => {
      resolve({
        close: evSource.close.bind(evSource),
      });
      resolved = true;
    });
    // A malformed payload thrown out of JSON.parse inside the listener
    // would escape to the EventSource's uncaught-handler path (the
    // awaiting consumer never sees it). Catch and close the stream so
    // either the resolve() above gets a deferred error or the still-
    // pending Promise rejects.
    const onParseError = (where: string, e: unknown): void => {
      evSource.close();
      const error = e instanceof Error ? e : new Error(String(e));
      if (resolved) console.error(`[${where}] ${error.message}`);
      else reject(error);
    };
    evSource.addEventListener("init", (e: MessageEvent<string>) => {
      try {
        const parsed = JSON.parse(e.data);
        update(() => expectEntriesWith(parsed, keyChecker, valueChecker), true);
      } catch (err) {
        onParseError("manageEntriesStream init", err);
      }
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      try {
        const parsed = JSON.parse(e.data);
        update(
          () => expectEntriesWith(parsed, keyChecker, valueChecker),
          false,
        );
      } catch (err) {
        onParseError("manageEntriesStream update", err);
      }
    });
    evSource.addEventListener("error", (e: MessageEvent<unknown>) => {
      const errorData = e.data;
      if (resolved) {
        console.error(errorData);
      } else {
        // Same shape as the close in manageStream below: without it
        // the EventSource keeps the connection alive (and keeps
        // reconnecting per the spec) after the caller has already
        // received a rejected Promise and will never call close().
        evSource.close();
        const error =
          errorData instanceof Error ? errorData : new Error(String(errorData));
        reject(error);
      }
    });
  });
}

export function manageStream<K extends Json>(
  url: string,
  init: (v: K[]) => void,
  update: (v: { updated: K[]; deleted: string[] }) => void,
  checker: (v: unknown, path: string) => K,
  params: { [name: string]: Json | null },
  headers?: { [name: string]: string },
): Promise<{
  readonly close: () => void;
}> {
  let resolved = false;
  return new Promise((resolve, reject) => {
    // Build URL with query params
    const searchParams = new URLSearchParams();
    for (const [k, v] of Object.entries(params)) {
      if (v === null) continue;
      if (typeof v === "object") searchParams.append(k, JSON.stringify(v));
      else searchParams.append(k, String(v));
    }
    const query = searchParams.toString();
    const fullUrl = query ? `${url}?${query}` : url;
    const evSource = headers
      ? new EventSource(fullUrl, {
          fetch: (input, init) =>
            fetch(input, { ...init, headers: { ...init.headers, ...headers } }),
        })
      : new EventSource(fullUrl);
    evSource.addEventListener("open", () => {
      resolve({
        close: evSource.close.bind(evSource),
      });
      resolved = true;
    });
    // Same parse-error containment as manageEntriesStream — see comment
    // there. Without it, JSON.parse / shape-check throws escape to the
    // EventSource's uncaught-handler path with no chance for the caller
    // to react.
    const onListenerError = (where: string, e: unknown): void => {
      evSource.close();
      const error = e instanceof Error ? e : new Error(String(e));
      if (resolved) console.error(`[${where}] ${error.message}`);
      else reject(error);
    };
    evSource.addEventListener("init", (e: MessageEvent<string>) => {
      try {
        init(expectArrayWith(JSON.parse(e.data), "Array", checker));
      } catch (err) {
        onListenerError("manageStream init", err);
      }
    });
    evSource.addEventListener("update", (e: MessageEvent<string>) => {
      try {
        const parsed = JSON.parse(e.data);
        if (!("updated" in parsed) || !("deleted" in parsed)) {
          throw new TypeError(
            message("", "{updated: Array; deleted: Array<string>}", parsed),
          );
        }
        const updated = expectArrayWith(
          parsed.updated,
          "Array",
          checker,
          ".updated",
        );
        const deleted = expectArrayWith(
          parsed.deleted,
          "Array<string>",
          expectString,
          ".deleted",
        );

        update({ updated, deleted });
      } catch (err) {
        onListenerError("manageStream update", err);
      }
    });
    evSource.addEventListener("error", (e: MessageEvent<unknown>) => {
      const errorData = e.data;
      if (resolved) {
        console.error(errorData);
      } else {
        evSource.close();
        const error =
          errorData instanceof Error ? errorData : new Error(String(errorData));
        reject(error);
      }
    });
  });
}

export function subscribe<
  K extends Json,
  V extends Json,
  P extends Json,
  ID extends Json,
>(
  service: ServiceInstance,
  streamId: string,
  convert: (entries: Entry<K, V>[]) => P[],
  getid: (entry: Entry<K, V>) => ID,
  stream: SkipStream,
  onInit: () => void,
): () => void {
  service.subscribe(streamId, {
    subscribed: () => onInit(),
    notify: (update: CollectionUpdate<K, V>) => {
      if (update.isInitial) {
        const metrics = convert(update.values);
        stream.write({
          event: "init",
          id: update.watermark,
          data: JSON.stringify(metrics),
        });
      } else {
        const updated = update.values.filter((v) => v[1].length > 0);
        const ids = new Set(updated.map((v) => getid(v)));
        const metrics = convert(updated);
        // with ordered keys ids can be updated and deleted at the same time
        const deleted = update.values
          .filter((v) => v[1].length === 0 && !ids.has(getid(v)))
          .map((v) => getid(v));

        stream.write({
          event: "update",
          id: update.watermark,
          data: JSON.stringify({ updated: metrics, deleted }),
        });
      }
    },
    close: () => {
      stream.close();
    },
  });
  return () => service.closeResourceInstance(streamId);
}

export function subscribeSingle<K extends Json, V extends Json, P extends Json>(
  service: ServiceInstance,
  streamId: string,
  convert: (entry: Entry<K, V>) => P,
  stream: SkipStream,
  onInit: () => void,
): () => void {
  service.subscribe(streamId, {
    subscribed: () => onInit(),
    notify: (update: CollectionUpdate<K, V>) => {
      // SkipRuntime fires notify with `update.values = []` in two cases
      // we must handle without crashing:
      //   1. `isInitial: true` on a freshly-instantiated single-value
      //      resource that hasn't produced its row yet (or whose key is
      //      not yet present in the upstream collection).
      //   2. `isInitial: false` on a downstream batch where every entry
      //      was filtered out before reaching this notifier.
      // The previous `update.values[0]!` non-null assertion crashed the
      // entire process on either case (`Cannot read properties of
      // undefined (reading '1')`) — taking down ALL active SSE streams
      // because the throw escapes the runtime's notifier callback.
      const skipValue = update.values[0];
      if (skipValue === undefined) return;
      if (update.isInitial) {
        stream.write({
          event: "init",
          id: update.watermark,
          data: JSON.stringify(convert(skipValue)),
        });
        return;
      }
      if (skipValue[1].length === 0) {
        stream.write({
          event: "delete",
          id: update.watermark,
          data: "",
        });
      } else {
        stream.write({
          event: "update",
          id: update.watermark,
          data: JSON.stringify(convert(skipValue)),
        });
      }
    },
    close: () => {
      stream.close();
    },
  });
  return () => service.closeResourceInstance(streamId);
}

export interface AuthenticationChecker<T, C> {
  // throw AuthenticationError in case of failure
  check(token: string, context: C): Promise<T>;
}

export interface HeadersAuthenticationChecker<T, C> {
  // throw AuthenticationError in case of failure
  check(header: { [name: string]: string }, context: C): Promise<T>;
}

export function extractCookie(
  cookieHeader: string | undefined,
  name: string,
): string | null {
  if (!cookieHeader) return null;
  const cookies = cookieHeader.split(";");
  for (const cookie of cookies) {
    const [key, ...rest] = cookie.trim().split("=");
    if (key === name) {
      return rest.join("=");
    }
  }
  return null;
}

/**
 * Order routes so that, at every path-segment position, a literal
 * segment is registered before a parameterised one. Express matches the
 * first registered handler that fits a request, so this ordering is
 * what guarantees a hit on `/pages/X/revisions/diff` reaches its own
 * handler instead of being captured by `/pages/{pageId}/revisions/{revisionNumber}`
 * (where `:revisionNumber` would greedily accept the literal `diff`).
 *
 * Segment-by-segment comparison: at the first divergence, literal beats
 * parameter; if both literal or both parameter, lexicographic. The
 * previous implementation treated *any* path containing `{` as dynamic
 * and compared the WHOLE path with `localeCompare` — which sorted by
 * the locale-dependent ordering of `{` vs letters and silently broke
 * the literal-first invariant whenever two paths share an early
 * parameter (e.g. both start with `/pages/{pageId}/`).
 * @returns the sorted commands
 */
export function sortCommands<T extends Command>(routes: T[]): T[] {
  const isParam = (segment: string): boolean =>
    segment.startsWith("{") && segment.endsWith("}");
  const split = (path: string): string[] => path.split("/").filter(Boolean);
  return [...routes].sort((a, b) => {
    const as = split(a.path);
    const bs = split(b.path);
    const len = Math.min(as.length, bs.length);
    for (let i = 0; i < len; i++) {
      const aParam = isParam(as[i]!);
      const bParam = isParam(bs[i]!);
      if (aParam !== bParam) return aParam ? 1 : -1;
      if (as[i] !== bs[i]) return as[i]!.localeCompare(bs[i]!);
    }
    return as.length - bs.length;
  });
}

export function getErrorMessage(error: unknown): string {
  if (error instanceof Error) return error.message;
  if (typeof error === "string") return error;
  return JSON.stringify(error);
}

export function validate<T>(
  value: unknown,
  validator: (v: unknown, p?: string) => T,
): T {
  try {
    return validator(value);
  } catch (e) {
    throw new CodeError(400, getErrorMessage(e));
  }
}
