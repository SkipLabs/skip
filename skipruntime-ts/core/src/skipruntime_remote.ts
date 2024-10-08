import type {
  Entry,
  ExternalSupplier,
  ReactiveResponse,
  TJSON,
} from "./skipruntime_api.js";

import { connect, Protocol, Client } from "@skipruntime/client";
import { fetchJSON, type Entrypoint } from "./skipruntime_rest.js";

interface Closable {
  close(): void;
}

export class RemoteResources implements ExternalSupplier {
  private client?: Promise<[Client, Protocol.Creds]>;
  private resources = new Map<string, Closable>();

  constructor(
    private uri: string,
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
  ): RemoteResources {
    let uri = `ws://${entrypoint.host}:${entrypoint.port.toString()}`;
    if (entrypoint.secured)
      uri = `wss://${entrypoint.host}:${entrypoint.port.toString()}`;
    return new RemoteResources(uri, auth, creds);
  }

  static direct(
    entrypoint: Entrypoint,
    creds?: Protocol.Creds,
  ): RemoteResources {
    let uri = `http://${entrypoint.host}:${entrypoint.port.toString()}`;
    if (entrypoint.secured)
      uri = `https://${entrypoint.host}:${entrypoint.port.toString()}`;
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
        `${uri}/v1/${resource}?${qParams}`,
        "HEAD",
        header,
      );
      const reactiveResponse = headers.get("x-reactive-response");
      if (!reactiveResponse)
        throw new Error("Reactive response must be suplied.");
      return JSON.parse(reactiveResponse) as ReactiveResponse;
    };
    return new RemoteResources(uri, auth, creds);
  }

  link(
    resource: string,
    params: Record<string, string>,
    cb: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void,
    reactiveAuth?: Uint8Array,
  ): void {
    if (!this.client) {
      if (!this.creds) {
        this.client = Protocol.generateCredentials().then((creds) => {
          this.creds = creds;
          return connect(this.uri, this.creds).then((c) => [c, creds]);
        });
      } else {
        this.client = connect(this.uri, this.creds).then((c) => {
          return [c, this.creds!];
        });
      }
    }
    this.link_(resource, params, cb, reactiveAuth).catch((e: unknown) => {
      console.error(e);
    });
  }

  close(
    resource: string,
    params: Record<string, string>,
    reactiveAuth?: Uint8Array,
  ) {
    const closable = this.resources.get(
      this.toId(resource, params, reactiveAuth),
    );
    if (closable) closable.close();
  }

  private async link_(
    resource: string,
    params: Record<string, string>,
    cb: (updates: Entry<TJSON, TJSON>[], isInit: boolean) => void,
    reactiveAuth?: Uint8Array,
  ): Promise<void> {
    const [client, creds] = await this.client!;
    const publicKey = new Uint8Array(await Protocol.exportKey(creds.publicKey));
    const reactive = await this.auth(resource, params, publicKey);
    const close = client.subscribe(
      reactive.collection,
      BigInt(reactive.watermark),
      cb,
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
