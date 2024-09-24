import type {
  SKStore,
  TJSON,
  Mapper,
  EagerCollection,
  NonEmptyIterator,
  SkipService,
  Resource,
} from "skip-runtime";

import { runService } from "skip-runtime";

import sqlite3 from "sqlite3";

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

class GetUserMapper implements Mapper<string, User, string, User> {
  constructor(private userId: string) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<User>,
  ): Iterable<[string, User]> {
    const user = it.first();
    if (key == this.userId) {
      return [[key, user]];
    }
    return [];
  }
}

class GetUserResource implements Resource {
  private params: {
    userId: string;
  };

  constructor(params: Record<string, string>) {
    this.params = params as {
      userId: string;
    };
  }

  reactiveCompute(
    _store: SKStore,
    cs: { users: EagerCollection<string, User> },
  ): EagerCollection<string, User> {
    return cs.users.map(GetUserMapper, this.params.userId);
  }
}

/*****************************************************************************/
// Setting up the service
/*****************************************************************************/

class Service implements SkipService {
  inputCollections = ["users"];
  resources = {
    user: GetUserResource,
  };
  async init() {
    const db = await initDB();
    const data = await new Promise<[string, TJSON][]>(function (
      resolve,
      reject,
    ) {
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
    return { users: data };
  }

  reactiveCompute(
    _store: SKStore,
    inputCollections: { users: EagerCollection<string, TJSON> },
  ): Record<string, EagerCollection<string, TJSON>> {
    return inputCollections;
  }
}

// Command that starts the service

await runService(new Service(), 8081);
