import type {
  SKStore,
  TJSON,
  EagerCollection,
  SkipService,
  Resource,
} from "@skipruntime/core";

import { runService } from "@skipruntime/server";

import sqlite3 from "sqlite3";

/*
  This is the skip runtime service of the database example  
*/

/*****************************************************************************/
// Populate the database with made-up values (if it's not already there)
/*****************************************************************************/

async function initDB(): Promise<sqlite3.Database> {
  const db = new sqlite3.Database("./db.sqlite");
  const exec = (query: string): Promise<void> => {
    return new Promise((resolve, reject) => {
      db.exec(query, (err) => {
        if (err) reject(err);
        else resolve();
      });
    });
  };
  const run = (
    query: string,
    params: Record<string, string>,
  ): Promise<void> => {
    return new Promise((resolve, reject) => {
      db.run(query, params, (err) => {
        if (err) reject(err);
        else resolve();
      });
    });
  };
  // Create the table if it doesn't exist
  await exec(`CREATE TABLE IF NOT EXISTS data (
    id TEXT PRIMARY KEY,
    object JSON
    )`);

  await run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "123",
    $object: JSON.stringify({
      name: "daniel",
      country: "FR",
    }),
  });
  await run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "124",
    $object: JSON.stringify({
      name: "josh",
      country: "UK",
    }),
  });
  await run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "125",
    $object: JSON.stringify({
      name: "julien",
      country: "ES",
    }),
  });
  return db;
}

/*****************************************************************************/
// The read path, we want to find a user
/*****************************************************************************/

type User = { name: string; country: string };

class UsersResource implements Resource {
  reactiveCompute(
    _store: SKStore,
    cs: { users: EagerCollection<string, User> },
  ): EagerCollection<string, User> {
    return cs.users;
  }
}

/*****************************************************************************/
// Setting up the service
/*****************************************************************************/

class Service implements SkipService {
  inputCollections: { users: [TJSON, TJSON][] };

  constructor(users: [TJSON, TJSON][]) {
    this.inputCollections = { users };
  }

  resources = {
    users: UsersResource,
  };

  reactiveCompute(
    _store: SKStore,
    inputCollections: { users: EagerCollection<string, TJSON> },
  ): Record<string, EagerCollection<string, TJSON>> {
    return inputCollections;
  }
}

// Command that starts the service

const db = await initDB();
const data = await new Promise<[string, User][]>(function (resolve, reject) {
  db.all(
    "SELECT id, object FROM data",
    (err, data: { id: string; object: string }[]) => {
      if (err) {
        reject(err);
      } else {
        resolve(data.map((v) => [v.id, JSON.parse(v.object)]));
      }
    },
  );
});
db.close();

await runService(new Service(data), 8081);
