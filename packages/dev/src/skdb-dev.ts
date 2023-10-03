import type { SKDB } from "skdb";
import { createSkdb } from "skdb";

async function getCreds(host: string, port: number, database: string) {
  const creds = new Map();
  try {
    const resp = await fetch(`http://${host}:${port}/dbs/${database}/users`)
    const data = await resp.text();
    const users = data.split("\n").filter(line => line.trim() != '').map(line => JSON.parse(line))
    for (const user of users) {
      creds.set(user.accessKey, user.privateKey)
    }
  } catch (ex: any) {
    throw new Error("Could not fetch from the dev server, is it running?")
  }

  return creds;
}

class DevServer {
  database: string;
  creds: Map<string, string>;
  host: string;
  port: number;

  constructor(database: string, host: string, port: number, creds: Map<string, string>) {
    this.database = database;
    this.host = host;
    this.port = port;
    this.creds = creds;
  }

  async connect(skdb: SKDB, accessKey: string): Promise<SKDB> {
    const b64privateKey = this.creds.get(accessKey);

    if (b64privateKey === undefined) {
      const accessKeys = Array.from(this.creds.keys());
      let help = ` We are aware of the following accessKeys: ${accessKeys}.`;
      if (accessKeys.length < 1) {
        help = ` Error in setup: we are not aware of any accessKeys.`;
      }
      throw new Error(`Could not find credential for ${accessKey}.${help}`);
    }

    const keyBytes = Uint8Array.from(atob(b64privateKey), c => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
      "raw", keyBytes, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);

    const endpoint = `ws://${this.host}:${this.port}`

    await skdb.connect(this.database, accessKey, key, endpoint);

    return skdb;
  }

  // TODO:
  async createUser() {}

  async schema(...stmts: string[]) {
    let resp;
    try {
      resp = await fetch(`http://${this.host}:${this.port}/dbs/${this.database}/schema`, {
        method: "PUT",
        body: stmts.map(s => s.endsWith(';') ? s : s + ';').join('\n'),
      });
    } catch (ex: any) {
      throw new Error("Could not fetch from the dev server, is it running?")
    }

    if (resp.status >= 300) {
      const msg = await resp.text();
      throw new Error(`Failed to setup the database: ${msg}`);
    }

    if (resp.status == 201) {
      console.warn("[skdb] Auto-migrated data to a new schema on a new database. Other clients may still be connected to the old database and will not replicate with this client.")
    }

    this.creds = await getCreds(this.host, this.port, this.database);
  }
}

export async function skdbDevServerDb(
  database: string = "test",
  host: string = "localhost",
  port: number = 3456,
): Promise<DevServer> {
  if (host.startsWith("http") || host.startsWith("https")) {
    throw new Error("host should be the hostname without scheme. Drop the http://.")
  }
  if (host.startsWith("ws://") || host.startsWith("wss://")) {
    throw new Error("host should be the hostname without scheme. Drop the ws://.")
  }

  const creds = await getCreds(host, port, database);
  return new DevServer(database, host, port, creds);
}

export async function createLocalDbConnectedTo(
  devServer: DevServer, accessKey: string = "root"
): Promise<SKDB> {
  let db = await createSkdb({asWorker: true});
  return devServer.connect(db, accessKey);
}
