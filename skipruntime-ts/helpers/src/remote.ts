import type {
  Entry,
  ExternalService,
  ReactiveResponse,
  TJSON,
} from "@skipruntime/api";
import { parseReactiveResponse } from "./utils.js";

import { connect, Protocol, Client } from "@skipruntime/client";
import { fetchJSON, type Entrypoint } from "./rest.js";

interface Closable {
  close(): void;
}

export class SkipExternalService implements ExternalService {
  private client?: Promise<[Client, Protocol.Creds]>;
  private resources = new Map<string, Closable>();

  constructor(
    private url: string,
    private auth: (
      resource: string,
      params: Record<string, string>,
      reactiveAuth: Uint8Array,
    ) => Promise<ReactiveResponse>,
    private creds?: Protocol.Creds,
  ) {}

  static fromEntrypoint(
    entrypoint: Entrypoint,
    auth: (
      resource: string,
      params: Record<string, string>,
      reactiveAuth: Uint8Array,
    ) => Promise<ReactiveResponse>,
    creds?: Protocol.Creds,
  ): SkipExternalService {
    let url = `ws://${entrypoint.host}:${entrypoint.port.toString()}`;
    if (entrypoint.secured)
      url = `wss://${entrypoint.host}:${entrypoint.port.toString()}`;
    return new SkipExternalService(url, auth, creds);
  }

  static direct(
    entrypoint: Entrypoint,
    creds?: Protocol.Creds,
  ): SkipExternalService {
    let url = `http://${entrypoint.host}:${entrypoint.port.toString()}`;
    if (entrypoint.secured)
      url = `https://${entrypoint.host}:${entrypoint.port.toString()}`;
    const auth = async (
      resource: string,
      params: Record<string, string>,
      reactiveAuth: Uint8Array,
    ) => {
      const qParams = new URLSearchParams(params).toString();
      const header = {
        "X-Reactive-Auth": Buffer.from(reactiveAuth).toString("base64"),
      };
      const [_data, headers] = await fetchJSON(
        `${url}/v1/${resource}?${qParams}`,
        "HEAD",
        header,
      );
      const reactiveResponse = parseReactiveResponse(headers);
      if (!reactiveResponse)
        throw new Error("Reactive response must be suplied.");
      return reactiveResponse;
    };
    return new SkipExternalService(url, auth, creds);
  }

  subscribe(
    resource: string,
    params: Record<string, string>,
    callbacks: {
      update: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void;
      error: (error: TJSON) => void;
      loading: () => void;
    },
    reactiveAuth?: Uint8Array,
  ): void {
    if (!this.client) {
      if (!this.creds) {
        this.client = Protocol.generateCredentials().then((creds) => {
          this.creds = creds;
          return connect(this.url, this.creds).then((c) => [c, creds]);
        });
      } else {
        this.client = connect(this.url, this.creds).then((c) => {
          return [c, this.creds!];
        });
      }
    }
    this.subscribe_(resource, params, callbacks, reactiveAuth).catch(
      (e: unknown) => {
        console.error(e);
      },
    );
  }

  unsubscribe(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ) {
    const closable = this.resources.get(
      this.toId(resource, params, reactiveAuth),
    );
    if (closable) closable.close();
  }

  shutdown(): void {
    if (this.client) {
      this.client
        .then((client) => {
          client[0].close();
        })
        .catch((e: unknown) => console.error(e));
    }
  }

  private async subscribe_(
    resource: string,
    params: Record<string, string>,
    callbacks: {
      update: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void;
      error: (error: TJSON) => void;
      loading: () => void;
    },
    reactiveAuth?: Uint8Array,
  ): Promise<void> {
    const [client, creds] = await this.client!;
    const publicKey = new Uint8Array(await Protocol.exportKey(creds.publicKey));
    const reactive = await this.auth(resource, params, publicKey);
    // TODO Manage Status
    const close = client.subscribe(
      reactive.collection,
      BigInt(reactive.watermark),
      callbacks.update,
    );
    this.resources.set(this.toId(resource, params, reactiveAuth), close);
  }

  private toId(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ): string {
    const strparams: string[] = [];
    for (const key of Object.keys(params).sort()) {
      strparams.push(`${key}:${params[key]}`);
    }
    const hex = reactiveAuth ? Buffer.from(reactiveAuth).toString("hex") : "";
    return `${resource}[${strparams.join(",")}]${hex}`;
  }
}
