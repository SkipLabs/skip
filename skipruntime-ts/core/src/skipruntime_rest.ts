import type { TJSON, Entry, ReactiveResponse } from "./skipruntime_api.js";

export type Entrypoint = {
  host: string;
  port: number;
  secured?: boolean;
};

function toHttp(entrypoint: Entrypoint) {
  if (entrypoint.secured)
    return `https://${entrypoint.host}:${entrypoint.port}`;
  return `http://${entrypoint.host}:${entrypoint.port}`;
}

export async function fetchJSON<V>(
  url: string,
  method: "POST" | "GET" | "PUT" | "PATCH" | "HEAD" | "DELETE" = "GET",
  headers: Record<string, string> = {},
  data?: TJSON,
): Promise<[V | null, Headers]> {
  const body = data ? JSON.stringify(data) : undefined;
  const response = await fetch(url, {
    method,
    body,
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      ...headers,
    },
    signal: AbortSignal.timeout(1000),
  });
  const responseJSON = method != "HEAD" ? ((await response.json()) as V) : null;
  if (!response.ok) {
    throw new Error(JSON.stringify(responseJSON));
  }
  return [responseJSON, response.headers];
}

export class SkipRESTRuntime {
  private entrypoint: string;

  constructor(
    entrypoint: Entrypoint = {
      host: "localhost",
      port: 3587,
    },
  ) {
    this.entrypoint = toHttp(entrypoint);
  }

  async getAll<K extends TJSON, V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array | string,
  ): Promise<{ values: Entry<K, V>[]; reactive?: ReactiveResponse }> {
    const qParams = new URLSearchParams(params).toString();
    let header = {};
    if (reactiveAuth) {
      if (typeof reactiveAuth == "string") {
        header = {
          "X-Reactive-Auth": reactiveAuth,
        };
      } else {
        header = {
          "X-Reactive-Auth": Buffer.from(reactiveAuth.buffer).toString(
            "base64",
          ),
        };
      }
    }
    const [optValues, headers] = await fetchJSON<Entry<K, V>[]>(
      `${this.entrypoint}/v1/${resource}?${qParams}`,
      "GET",
      header,
    );
    const strReactiveResponse = headers.get("x-reactive-response");
    const reactive = strReactiveResponse
      ? (JSON.parse(strReactiveResponse, (key: string, value: string) => {
          if (key == "watermark") return BigInt(value);
          return value;
        }) as ReactiveResponse)
      : undefined;
    const values = optValues ?? [];
    return reactive ? { values, reactive } : { values };
  }

  async head(
    resource: string,
    params: Record<string, string>,
    reactiveAuth: Uint8Array | string,
  ): Promise<ReactiveResponse> {
    const qParams = new URLSearchParams(params).toString();
    const header = this.header(reactiveAuth);
    const [_data, headers] = await fetchJSON(
      `${this.entrypoint}/v1/${resource}?${qParams}`,
      "HEAD",
      header,
    );
    const reactiveResponse = headers.get("x-reactive-response");
    if (!reactiveResponse)
      throw new Error("Reactive response must be suplied.");
    return JSON.parse(reactiveResponse, (key: string, value: string) => {
      if (key == "watermark") return BigInt(value);
      return value;
    }) as ReactiveResponse;
  }

  async getOne<V extends TJSON>(
    resource: string,
    params: Record<string, string>,
    key: string,
    reactiveAuth?: Uint8Array | string,
  ): Promise<V[]> {
    const qParams = new URLSearchParams(params).toString();
    const header = this.header(reactiveAuth);
    const [data, _headers] = await fetchJSON<V[]>(
      `${this.entrypoint}/v1/${resource}/${key}?${qParams}`,
      "GET",
      header,
    );
    return data ?? [];
  }

  async put<V extends TJSON>(
    collection: string,
    key: string,
    value: V[],
  ): Promise<void> {
    await fetchJSON(
      `${this.entrypoint}/v1/${collection}/${key}`,
      "PUT",
      {},
      value,
    );
  }

  async patch<K extends TJSON, V extends TJSON>(
    collection: string,
    values: Entry<K, V>[],
  ): Promise<void> {
    await fetchJSON(`${this.entrypoint}/v1/${collection}`, "PATCH", {}, values);
  }

  async deleteKey(collection: string, key: string): Promise<void> {
    await fetchJSON(`${this.entrypoint}/v1/${collection}/${key}`, "DELETE", {});
  }

  private header(reactiveAuth?: Uint8Array | string): Record<string, string> {
    if (reactiveAuth) {
      if (typeof reactiveAuth == "string") {
        return {
          "X-Reactive-Auth": reactiveAuth,
        };
      } else {
        return {
          "X-Reactive-Auth": Buffer.from(reactiveAuth.buffer).toString(
            "base64",
          ),
        };
      }
    }
    return {};
  }
}
