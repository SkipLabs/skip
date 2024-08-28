import type {
  EagerCollection,
  Mapper,
  NonEmptyIterator,
  Param,
  SKStore,
  TJSON,
} from "./skipruntime_api.js";

import type { Writer } from "./skipruntime_service.js";

export type HTTPResponse = {
  code: number;
  payload: TJSON;
};

export const BadRequest = {
  code: 400,
  payload: "Bad Request",
};

export const Success = {
  code: 202,
  payload: "",
};

interface HTTPRESTRunner {
  execRequest(
    store: SKStore,
    payload: string[],
    inputCollections: Record<string, EagerCollection<number, TJSON>>,
  ): HTTPResponse;
}

export type HTTPRESTRequestDefinition = {
  path: string[];
  runner: new (...params: Param[]) => HTTPRESTRunner;
  params: Param[];
};

export type HTTPRESTGetRequest = {
  path: string[];
  runner: HTTPRESTRunner;
};

function resolve(path: string, requestPath: string[]): string[] | null {
  const elements = path.split("/");
  if (elements.length != requestPath.length) {
    return null;
  }
  const variables: string[] = [];
  for (let [idx, part] of requestPath.entries()) {
    if (part.match(/^{[a-z0-1A-Z]+}$/g)) {
      // variable
      variables.push(elements[idx]);
    } else if (elements[idx] != part) {
      return null;
    }
  }
  return variables;
}

export type HTTPPost = { path: string; payload: TJSON };

function asHTTPPost(event: TJSON) {
  if (typeof event != "object") return null;
  if (!("path" in event)) return null;
  if (!("payload" in event)) return null;
  return event as HTTPPost;
}

export class RequestMapper
  implements Mapper<number, TJSON, number, HTTPResponse>
{
  constructor(
    private requests: HTTPRESTGetRequest[],
    private sktore: SKStore,
    private inputCollections: Record<string, EagerCollection<number, TJSON>>,
  ) {}

  mapElement(key: number, it: NonEmptyIterator<TJSON>) {
    let response = BadRequest;
    const path = it.first() as string;
    for (const request of this.requests) {
      const payload = resolve(path, request.path);
      if (payload == null) continue;
      request.runner.execRequest(this.sktore, payload, this.inputCollections);
      break;
    }
    return Array([key, response] as [number, HTTPResponse]);
  }
}

export type HTTPRESTWriteRequest = {
  path: string[];
  writer: (
    variables: string[],
    payload: TJSON,
    writers: Record<string, Writer<TJSON>>,
    remotes: Record<string, (event: TJSON) => Promise<void>>,
  ) => Promise<void>;
};

export type Write = (
  writers: Record<string, Writer<TJSON>>,
  remotes: Record<string, (event: TJSON) => Promise<void>>,
) => Promise<void>;

export class RESTWriter {
  private managers: HTTPRESTWriteRequest[];
  constructor() {
    this.managers = [];
  }

  on(
    path: string,
    writer: (
      variables: string[],
      payload: TJSON,
      writers: Record<string, Writer<TJSON>>,
      remotes: Record<string, (event: TJSON) => Promise<void>>,
    ) => Promise<void>,
  ) {
    this.managers.push({
      path: path.split("/"),
      writer,
    });
  }

  resolve(event: TJSON): Write | null {
    const post = asHTTPPost(event);
    if (!post) return null;
    for (const manager of this.managers) {
      const variables = resolve(post.path, manager.path);
      if (variables == null) continue;
      return (
        writers: Record<string, Writer<TJSON>>,
        remotes: Record<string, (event: TJSON) => Promise<void>>,
      ) => {
        return manager.writer(variables, post.payload, writers, remotes);
      };
    }
    return null;
  }
}
