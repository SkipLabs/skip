import {
  buildCacheControlHeader,
  checkCache,
  configCors,
  type Command,
  type RestService,
  type Route,
  type Json,
  SkipResponse,
  SkipRedirect,
  type StreamData,
  POST,
  PUT,
  PATCH,
  GET,
  DELETE,
  HEAD,
  OPTIONS,
  TRACE,
  CONNECT,
  type SkipStreamer,
  sortCommands,
} from "@skipruntime/skipper-helpers";
import express from "express";
import type { Request, Response, NextFunction } from "express";
import busboy from "busboy";
import { createWriteStream } from "node:fs";
import { mkdir } from "node:fs/promises";
import { join, resolve as resolvePath } from "node:path";
import { randomUUID } from "node:crypto";

/**
 * Convert OpenAPI path to Express path format.
 * - {id} → :id
 * - {path*} → :path(*)
 * @param path - OpenAPI path format
 * @returns Express path format
 */
function toExpressPath(path: string): string {
  return path.replace(/\{(\w+)\*\}/g, ":$1(*)").replace(/\{(\w+)\}/g, ":$1");
}

/**
 * Parse multipart/form-data requests, streaming file parts to disk under a
 * per-request directory and merging text/JSON fields into `req.body`.
 *
 * **File parts arrive as absolute path strings on `req.body`.** Each file
 * part is streamed into `<SKIPPER_REQUEST_DIR>/<requestId>/<fieldname>` (where
 * `SKIPPER_REQUEST_DIR` defaults to `./data/requests/` relative to the
 * server's CWD, and `<requestId>` is a freshly-generated UUID per request).
 * The value stored at `body[<fieldname>]` is the resulting absolute path —
 * NOT the bytes. The downstream route handler forwards the path to the
 * subprocess external (typically via `payload.key`), and the external does
 * `await readFile(path)` to consume the bytes. The framework does NOT
 * delete the file: the consumer (the external that reads it) owns cleanup,
 * because the framework cannot know when reactive recomputation might
 * still need the bytes. This avoids the body→ subprocess race that
 * cleanup-on-response-end would create.
 *
 * **JSON parts are auto-parsed.** When a text or file part has a JSON
 * Content-Type, the bytes are JSON-parsed and stored under the field name as
 * the parsed value. Non-JSON text fields are stored verbatim. This is what
 * lets multipart endpoints whose OpenAPI schema declares a `metadata:
 * $ref<…>` (object-shaped) part work end-to-end: the validator gets a
 * parsed object, not a path. Without this branch, the validator's
 * `expectObject(o.metadata)` would fail and the request would 400 before
 * reaching the handler.
 *
 * **Why a per-request dir, not a flat namespace**: two concurrent multipart
 * requests with the same field name (`model.scad`) would race on a flat
 * namespace; the per-request UUID dir isolates them with zero coordination.
 *
 * **Why disk, not base64 in memory**: large CAD models / images / archives
 * (up to 50 MiB by default) would inflate the JSON body 33% if base64-
 * encoded, double the memory footprint of every request, and force the
 * downstream external to base64-decode the bytes again before processing.
 * A path string is small and cache-friendly through the runtime.
 */
function multipartMiddleware(
  req: Request,
  _res: Response,
  next: NextFunction,
): void {
  const contentType = req.headers["content-type"] ?? "";
  if (!contentType.includes("multipart/form-data")) {
    next();
    return;
  }
  const requestDirRoot = resolvePath(
    process.env["SKIPPER_REQUEST_DIR"] ?? "./data/requests",
  );
  const requestId = randomUUID();
  const requestDir = join(requestDirRoot, requestId);
  const body: { [name: string]: unknown } = {};
  const setField = (name: string, value: unknown) => {
    const existing = body[name];
    if (existing === undefined) {
      body[name] = value;
    } else if (existing instanceof Array) {
      existing.push(value);
    } else {
      body[name] = [existing, value];
    }
  };
  const isJsonMime = (mimeType: string | undefined): boolean => {
    if (mimeType === undefined) return false;
    const head = mimeType.split(";")[0]!.trim().toLowerCase();
    return head === "application/json" || head === "text/json";
  };
  const pending: Promise<void>[] = [];
  mkdir(requestDir, { recursive: true })
    .then(() => {
      const bb = busboy({
        headers: req.headers,
        limits: { fileSize: 50 * 1024 * 1024 },
      });
      bb.on("file", (name, file, info) => {
        if (isJsonMime(info.mimeType)) {
          // Small JSON metadata parts uploaded as files (rare but valid):
          // buffer + parse like a text field rather than write to disk.
          const chunks: Buffer[] = [];
          file.on("data", (chunk: Buffer) => chunks.push(chunk));
          file.on("end", () => {
            const concat = Buffer.concat(chunks);
            try {
              setField(name, JSON.parse(concat.toString("utf-8")));
            } catch {
              // Malformed JSON declared as application/json: store the path
              // anyway so the downstream validator surfaces the shape
              // mismatch instead of the middleware swallowing the bytes.
              setField(name, concat.toString("base64"));
            }
          });
          return;
        }
        // Binary or other-typed file part: stream to disk and store the path.
        const filePath = join(requestDir, name);
        const out = createWriteStream(filePath);
        file.pipe(out);
        pending.push(
          new Promise<void>((resolve, reject) => {
            out.on("finish", () => {
              setField(name, filePath);
              resolve();
            });
            out.on("error", reject);
          }),
        );
      });
      bb.on("field", (name, value: string, info) => {
        if (isJsonMime(info.mimeType)) {
          try {
            setField(name, JSON.parse(value));
            return;
          } catch {
            // Same fallback as the file case.
          }
        }
        setField(name, value);
      });
      bb.on("close", () => {
        Promise.all(pending).then(
          () => {
            req.body = body;
            next();
          },
          (err: unknown) =>
            next(err instanceof Error ? err : new Error(String(err))),
        );
      });
      bb.on("error", (err: unknown) => {
        next(err instanceof Error ? err : new Error(String(err)));
      });
      req.pipe(bb);
    })
    .catch((err: unknown) =>
      next(err instanceof Error ? err : new Error(String(err))),
    );
}

/**
 * Flatten Express's `IncomingHttpHeaders` (where values may be `string`,
 * `string[]`, or `undefined`) into the `{ [name: string]: string }` shape
 * expected by `checkCache`. For multi-value headers, take the first one —
 * conditional cache headers (If-Match, If-None-Match, …) are single-valued
 * by spec.
 * @returns the flatten headers
 */
function flatHeaders(
  headers: Record<string, string | string[] | undefined>,
): Record<string, string> {
  const out: Record<string, string> = {};
  for (const [k, v] of Object.entries(headers)) {
    if (typeof v === "string") out[k] = v;
    else if (Array.isArray(v) && v.length > 0) out[k] = v[0]!;
  }
  return out;
}

/**
 * Clean Express params by removing numeric keys (e.g., "0" from wildcard captures).
 * @param params - Express request params
 * @returns Cleaned params object
 */
function cleanParams(
  params: Record<string, string | string[]>,
): Record<string, string | string[]> {
  const result: Record<string, string | string[]> = {};
  for (const [key, value] of Object.entries(params)) {
    if (!/^\d+$/.test(key)) {
      result[key] = value;
    }
  }
  return result;
}

export default function manageRoutes(
  service: RestService,
  json: boolean = true,
): {
  listen: (
    port: number,
    callback: (error?: Error) => void,
    hostname?: string,
  ) => () => Promise<void>;
  port?: number;
} {
  const app = express().use(
    (req: Request, res: Response, next: NextFunction) => {
      if (service.options?.cors) {
        const cors = service.options.cors();
        if (cors === false) {
          res.header("Access-Control-Allow-Credentials", "true");
          res.header("Access-Control-Allow-Methods", methods.join(","));
          res.header("Access-Control-Allow-Origin", "*");
        } else {
          const origin = req.headers.origin;
          configCors(cors, res.header.bind(res), origin);
        }
      }
      next();
    },
  );
  // Sort once: literal paths (no `{`) come BEFORE parameterised paths so
  // a hit on `/users/search` is routed to its own handler rather than
  // captured by `/users/{userId}` (which Express would otherwise match
  // greedily — the param wildcard accepts the literal `search` and the
  // request lands in getUserById, returning a confusing 404).
  const sortedCommands = sortCommands(service.commands);
  const methods = sortedCommands.map((c: Command) => c.method);
  app.use(multipartMiddleware);
  if (json) {
    app.use(express.json({ strict: false, limit: "10mb" }));
  } else {
    app.use(express.text());
  }
  app.use(logger);
  if (service.options?.healthcheck) {
    app.get(`/${service.options.healthcheck}`, (_, res) => {
      res.sendStatus(200);
    });
  }
  if (service.options?.openapiJson) {
    const openapiContent = service.options.openapiJson;
    app.get("/openapi.json", (_, res) => {
      res.header("Content-Type", "application/json");
      res.send(openapiContent);
    });
  }
  if (service.options?.indexHtml) {
    const indexHtml = service.options.indexHtml;
    app.get("/", (_, res) => {
      res.header("Content-Type", "text/html; charset=utf-8");
      res.send(indexHtml);
    });
  }
  if (
    service.options &&
    Object.prototype.hasOwnProperty.call(service.options, "googleClientId")
  ) {
    const googleClientId = service.options.googleClientId;
    app.get("/get-google-client-id", (_, res) => {
      res.header("Content-Type", "application/json");
      res.send({ clientId: googleClientId });
    });
  }
  if (service.options?.htmlPages) {
    for (const [path, html] of Object.entries(service.options.htmlPages)) {
      if (path === "/") continue;
      app.get(path, (_, res) => {
        res.header("Content-Type", "text/html; charset=utf-8");
        res.send(html);
      });
    }
  }

  for (const command of sortedCommands) {
    let withBody = false;
    switch (command.method) {
      case POST:
      case PUT:
      case PATCH:
        withBody = true;
        break;
      default:
        break;
    }

    const requestHandler = async (
      sreq: Route<unknown>,
      req: Request,
      res: Response,
    ) => {
      // Per-request JSON negotiation: a client that asks for JSON
      // (`Accept: application/json` — Express's `accepts(...)` also
      // matches `*/*`, `application/*`, and the absence of an Accept
      // header) gets structured error bodies; everything else keeps
      // the legacy plain-text replies. Computed once up-front so both
      // the success path and the catch can read the same value.
      const wantsJson = req.accepts("application/json") !== false;
      void wantsJson; // wired into the error-catch shortly
      try {
        const params = cleanParams(req.params);
        const body = withBody ? req.body : undefined;
        const result = await sreq.perform(params, body, req.query, req.headers);

        // Execute command

        // Handle response
        // Temporary hack to manage bundler
        if (result.constructor.name === "SkipRedirect") {
          const redirect = result as any as SkipRedirect;
          res.redirect(redirect.code, redirect.url);
        } else if (result.constructor.name === "SkipResponse") {
          // Conditional-request handling (If-Match, If-None-Match,
          // If-Modified-Since, If-Unmodified-Since): may rewrite the
          // response to 304/412 before any body is sent.
          const response = checkCache(
            flatHeaders(req.headers),
            result as any as SkipResponse<Json | undefined>,
          );
          // Set custom headers if provided
          if (response.headers) {
            Object.entries(response.headers).forEach(([name, value]) => {
              res.header(name, value);
            });
          }

          // Set ETag if provided
          if (response.etag) {
            res.header("ETag", response.etag);
          }

          // Set Last-Modified if provided
          if (response.lastModified) {
            res.header("Last-Modified", response.lastModified.toUTCString());
          }

          // Set Cache-Control from declarative route configuration
          if (sreq.cache) {
            res.header("Cache-Control", buildCacheControlHeader(sreq.cache));
          }

          // Send response. When `contentType` is set on the SkipResponse
          // (text/plain, text/html, ...), bypass JSON serialisation and emit
          // the body as-is with the declared Content-Type. Otherwise fall
          // back to the service-level `json` switch.
          if (response.body === undefined) {
            res.sendStatus(response.status);
          } else if (response.contentType) {
            res
              .header("Content-Type", response.contentType)
              .status(response.status)
              .send(response.body);
          } else if (json) {
            res.status(response.status).json(response.body);
          } else {
            res.status(response.status).send(response.body);
          }
        } else if ("stream" in result && typeof result.stream === "function") {
          const streamer: SkipStreamer = result;
          const stream = {
            write: (data: StreamData) => {
              res.write(`event: ${data.event}\n`);
              res.write(`id: ${data.id}\n`);
              res.write(`data: ${data.data}\n\n`);
            },
            close: () => {
              res.end();
            },
          };
          let streamResult = streamer.stream(stream, (status) => {
            res.set("Content-Type", "text/event-stream");
            res.set("Connection", "keep-alive");
            res.set("Cache-Control", "no-cache");
            res.status(status);
            res.flushHeaders();
          });
          if (streamResult instanceof Promise) {
            streamResult = await streamResult;
          }
          const heartbeat = setInterval(() => {
            res.write("event: update\ndata:[]\n\n");
          }, 30000);
          req.on("close", () => {
            clearInterval(heartbeat);
            const res = streamResult.close();
            if (res instanceof Promise) res.catch(console.error);
          });
        } else {
          console.error("Unknown response type", result);
          res.sendStatus(500);
        }
      } catch (error) {
        if (error && typeof error === "object") {
          if (error.constructor.name === "AuthenticationError") {
            res.sendStatus(401);
          } else if (error.constructor.name === "InvalidParameterError") {
            res.sendStatus(400);
          } else if (error.constructor.name === "ConflictError") {
            res.sendStatus(409);
          } else if (
            error.constructor.name === "CodeError" &&
            "code" in error &&
            typeof error.code === "number" &&
            "error" in error &&
            typeof error.error === "string"
          ) {
            // CodeError carries a status, a plain `error` payload, and an
            // optional `contentType`. Non-JSON content types (text/html for
            // HTML error pages, text/plain for raw text) bypass `.json()`
            // so the response body is emitted verbatim with the declared
            // Content-Type header.
            const contentType =
              "contentType" in error && typeof error.contentType === "string"
                ? error.contentType
                : undefined;
            if (contentType) {
              res
                .header("Content-Type", contentType)
                .status(error.code)
                .send(error.error);
            } else if (wantsJson) {
              res
                .header("Content-Type", "application/json")
                .status(error.code)
                .send({ code: error.code, message: error.error });
            } else {
              res.status(error.code).send(error.error);
            }
          } else {
            console.error(error);
            res.sendStatus(500);
          }
        } else {
          console.error(error);
          res.sendStatus(500);
        }
      }
    };

    const handler = async (req: Request, res: Response) => {
      if (!("perform" in command)) {
        console.error("Request not implemented");
        res.sendStatus(501);
        return;
      }
      // Routes that declare `accepted` (e.g. SSE endpoints with
      // `accepted: ["text/event-stream"]`) require the request's
      // Accept header to match one of the listed media types.
      // Mismatches must short-circuit with 406 Not Acceptable instead
      // of dispatching to a handler that would emit the wrong shape.
      if (command.accepted && command.accepted.length > 0) {
        if (!req.accepts(command.accepted)) {
          res.sendStatus(406);
          return;
        }
      }
      await requestHandler(command as Route<Json>, req, res);
    };

    // Register route based on method
    const expressPath = toExpressPath(command.path);
    switch (command.method) {
      case GET:
        app.get(expressPath, handler);
        break;
      case POST:
        app.post(expressPath, handler);
        break;
      case PUT:
        app.put(expressPath, handler);
        break;
      case PATCH:
        app.patch(expressPath, handler);
        break;
      case DELETE:
        app.delete(expressPath, handler);
        break;
      case HEAD:
        app.head(expressPath, handler);
        break;
      case OPTIONS:
        app.options(expressPath, handler);
        break;
      case TRACE:
        app.trace(expressPath, handler);
        break;
      case CONNECT:
        app.connect(expressPath, handler);
        break;
      default:
        console.warn(`Unknown HTTP method: ${command.method}`);
    }
  }
  const listen = (
    port: number,
    callback: (error?: Error) => void,
    hostname?: string,
  ) => {
    let server;
    if (hostname) server = app.listen(port, hostname, callback);
    else server = app.listen(port, callback);
    // `server.close()` stops accepting new connections and emits its
    // own callback once every active socket has closed. Wrap that in
    // a Promise so callers (the SIGINT handler in the generated
    // project template) can await drain before forcing exit.
    return () =>
      new Promise<void>((resolve, reject) => {
        server.close((err) => (err ? reject(err) : resolve()));
      });
  };
  return { listen, port: service.options?.port };
}

function logger(req: Request, res: Response, next: NextFunction) {
  const start = Date.now();
  console.log(
    JSON.stringify({
      event: "request",
      host: req.headers.host,
      method: req.method,
      path: req.originalUrl,
    }),
  );
  res.on("finish", () => {
    console.log(
      JSON.stringify({
        event: "response",
        host: req.headers.host,
        method: req.method,
        path: req.originalUrl,
        status: res.statusCode,
        duration_ms: Date.now() - start,
      }),
    );
  });
  next();
}
