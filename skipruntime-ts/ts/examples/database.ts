import type {
  SKStore,
  TJSON,
  Mapper,
  EagerCollection,
  NonEmptyIterator,
  SimpleSkipService,
  SimpleServiceOutput,
  JSONObject,
  Writer,
} from "skip-runtime";

import { runWithServer } from "skip-runtime";

import sqlite3 from "sqlite3";
const db = new sqlite3.Database("./db.sqlite");

/*****************************************************************************/
// Populating the database with made-up values (if it's not already there)
/*****************************************************************************/

async function initDB(): Promise<void> {
  // Create the table if it doesn't exist
  await db.exec(`CREATE TABLE IF NOT EXISTS data (
    id TEXT PRIMARY KEY,
    object JSON
    )`);

  await db.run(
    "INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)",
    {
      $id: "123",
      $object: JSON.stringify({
        name: "daniel",
        country: "FR",
      }),
    },
  );
  await db.run(
    "INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)",
    {
      $id: "124",
      $object: JSON.stringify({
        name: "josh",
        country: "UK",
      }),
    },
  );
  await db.run(
    "INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)",
    {
      $id: "125",
      $object: JSON.stringify({
        name: "julien",
        country: "ES",
      }),
    },
  );
}

/*****************************************************************************/
// The protocol
/*****************************************************************************/

type Command = {
  command: "getUser" | "set" | "delete";
  payload: TJSON;
};

type GetUser = string;
type Set = { key: string; value: string }[];
type Delete = { keys: string[] }[];

/*****************************************************************************/
// The read path, we want to find a user
/*****************************************************************************/

type User = {
  name: string;
  country: string;
};

type Response = { status: "error"; msg: string } | { status: "ok"; user: User };

class Request implements Mapper<string, TJSON, string, TJSON> {
  constructor(private users: EagerCollection<string, TJSON>) {}

  mapElement(
    key: string,
    it: NonEmptyIterator<TJSON>,
  ): Iterable<[string, TJSON]> {
    const v = it.first() as JSONObject;
    let computed: Response;
    const value = this.users.maybeGetOne(v.payload as GetUser);
    const user = value as User;
    if (v.command == "getUser") {
      computed = { status: "ok", user };
    } else {
      computed = { status: "error", msg: "Unknown command" };
    }
    return Array([key, computed]);
  }
}

/*****************************************************************************/
// The write path
/*****************************************************************************/

async function update(
  event: TJSON,
  writers: Record<string, Writer<TJSON>>,
): Promise<void> {
  const writer = writers["users"];
  const cmd = event as Command;
  if (cmd.command == "set") {
    const payload = cmd.payload as Set;
    for (const e of payload) {
      await db.run(
        "INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)",
        {
          $id: e.key,
          $object: JSON.stringify(e.value),
        },
      );
      writer.set(e.key, e.value);
    }
  } else if (cmd.command == "delete") {
    const payload = cmd.payload as Delete;
    for (const e of payload) {
      for (const key of e.keys) {
        await db.run("DELETE FROM data WHERE id = $id", { $id: key });
      }
      writer.delete(e.keys);
    }
  }
}

/*****************************************************************************/
// Setting up the service
/*****************************************************************************/

class Service implements SimpleSkipService {
  name: string = "database-example";
  inputTables = ["users"];

  async init(tables: Record<string, Writer<TJSON[]>>) {
    await initDB();
    db.all(
      "SELECT id, object FROM data",
      (err, data: Array<{ id: string; object: string }>) => {
        const userWriter = tables["users"];
        for (const user of data) {
          userWriter.set(user.id, JSON.parse(user.object));
        }
      },
    );
    console.log("Initializing done.");
    console.log("Service is ready!");
  }

  reactiveCompute(
    _store: SKStore,
    requests: EagerCollection<string, TJSON>,
    inputCollections: Record<string, EagerCollection<string, TJSON>>,
  ): SimpleServiceOutput {
    const output = requests.map(Request, inputCollections["users"]);
    return { output, update };
  }
}

// Command that starts the service

runWithServer(new Service(), { port: 8081 });
