/* eslint-disable @typescript-eslint/no-unsafe-call */
import type {
  EagerCollection,
  SkipService,
  Resource,
  Entry,
} from "@skipruntime/core";

import { runService } from "@skipruntime/server";

/*
  This is the skip runtime service of the database example
*/

const platform: "wasm" | "native" =
  process.env["SKIP_PLATFORM"] == "native" ? "native" : "wasm";

/*****************************************************************************/
// Conditional database driver loading: bun:sqlite under Bun, better-sqlite3 under Node
/*****************************************************************************/

async function getDatabase(): Promise<any> {
  // @ts-expect-error - Bun is not typed in a Node environment
  if (typeof Bun !== "undefined") {
    // @ts-expect-error - bun:sqlite is only available under Bun
    const mod = await import("bun:sqlite");
    return mod.Database;
  } else {
    const mod = await import("better-sqlite3");
    return mod.default;
  }
}

const Database = await getDatabase();

/*****************************************************************************/
// Populate the database with made-up values (if it's not already there)
/*****************************************************************************/

function initDB(): any {
  const db = new Database("./db.sqlite");

  // Create the table if it doesn't exist
  db.prepare(
    `CREATE TABLE IF NOT EXISTS data (
      id TEXT PRIMARY KEY,
      object JSON
    )`,
  ).run();

  const insertOrReplace = db.prepare(
    "INSERT OR REPLACE INTO data (id, object) VALUES (?, ?)",
  );

  insertOrReplace.run("123", JSON.stringify({ name: "daniel", country: "FR" }));
  insertOrReplace.run("124", JSON.stringify({ name: "josh", country: "UK" }));
  insertOrReplace.run("125", JSON.stringify({ name: "julien", country: "ES" }));

  return db;
}

/*****************************************************************************/
// The read path, we want to find a user
/*****************************************************************************/

type User = { name: string; country: string };

type UsersCollection = {
  users: EagerCollection<string, User>;
};
class UsersResource implements Resource<UsersCollection> {
  instantiate(cs: UsersCollection): UsersCollection["users"] {
    return cs.users;
  }
}

/*****************************************************************************/
// Setting up the service
/*****************************************************************************/

function serviceWithInitialData(
  users: Entry<string, User>[],
): SkipService<UsersCollection, UsersCollection> {
  return {
    initialData: { users },
    resources: { users: UsersResource },
    createGraph: (inputCollections) => inputCollections,
  };
}

// Command that starts the service

const db = initDB();
const data: Entry<string, User>[] = (
  db.prepare("SELECT id, object FROM data").all() as {
    id: string;
    object: string;
  }[]
).map((v) => [v.id, [JSON.parse(v.object) as User]]);

db.close();

const server = await runService(serviceWithInitialData(data), {
  streaming_port: 8080,
  control_port: 8081,
  platform,
});

async function shutdown() {
  await server.close();
}

// eslint-disable-next-line @typescript-eslint/no-misused-promises
["SIGTERM", "SIGINT"].map((sig) => process.on(sig, shutdown));
