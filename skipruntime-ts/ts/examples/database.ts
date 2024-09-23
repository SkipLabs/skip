import type {
  SKStore,
  TJSON,
  EagerCollection,
  SimpleSkipService,
  SimpleServiceOutput,
  Writer,
} from "skip-runtime";

import { runWithServer, ValueMapper } from "skip-runtime";

import sqlite3 from "sqlite3";

/*****************************************************************************/
// Populate the database with made-up values (if it's not already there)
/*****************************************************************************/

function initDB(): sqlite3.Database {
  const db = new sqlite3.Database("./db.sqlite");
  // Create the table if it doesn't exist
  db.exec(`CREATE TABLE IF NOT EXISTS data (
    id TEXT PRIMARY KEY,
    object JSON
    )`);

  db.run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "123",
    $object: JSON.stringify({ name: "daniel", country: "FR" }),
  });
  db.run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "124",
    $object: JSON.stringify({ name: "josh", country: "UK" }),
  });
  db.run("INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)", {
    $id: "125",
    $object: JSON.stringify({ name: "julien", country: "ES" }),
  });
  return db;
}

const db = initDB();

/*****************************************************************************/
// The protocol
/*****************************************************************************/

type Command =
  | { command: "getUser"; payload: string }
  | { command: "set"; payload: { key: string; value: string }[] }
  | { command: "delete"; payload: { keys: string[] }[] };

/*****************************************************************************/
// The read path, we want to find a user
/*****************************************************************************/

type User = { name: string; country: string };

type Response = { status: "error"; msg: string } | { status: "ok"; user: User };

class Request extends ValueMapper<string, Command, Response> {
  constructor(private users: EagerCollection<string, TJSON>) {
    super();
  }

  mapValue(cmd: Command): Response {
    switch (cmd.command) {
      case "getUser": {
        const user = this.users.maybeGetOne(cmd.payload) as User;
        return { status: "ok", user };
      }
      default:
        return { status: "error", msg: "Unknown command" };
    }
  }
}

/*****************************************************************************/
// The write path
/*****************************************************************************/

function update(event: TJSON, writers: Record<string, Writer<string>>): void {
  const writer = writers["users"];
  const cmd = event as Command;
  switch (cmd.command) {
    case "set": {
      for (const entry of cmd.payload) {
        db.run(
          "INSERT OR REPLACE INTO data (id, object) VALUES ($id, $object)",
          {
            $id: entry.key,
            $object: JSON.stringify(entry.value),
          },
        );
        writer.set(entry.key, entry.value);
      }
      break;
    }
    case "delete": {
      for (const entry of cmd.payload) {
        for (const key of entry.keys) {
          db.run("DELETE FROM data WHERE id = $id", { $id: key });
        }
        writer.delete(entry.keys);
      }
      break;
    }
  }
}

/*****************************************************************************/
// Setting up the service
/*****************************************************************************/

class Service implements SimpleSkipService {
  name: string = "database-example";
  inputTables = ["users"];

  init(tables: Record<string, Writer<TJSON[]>>) {
    db.all(
      "SELECT id, object FROM data",
      (_err, data: { id: string; object: string }[]) => {
        const userWriter = tables["users"];
        for (const user of data) {
          const json: User = JSON.parse(user.object);
          userWriter.set(user.id, [json]);
        }
      },
    );
    console.log("Initializing done.");
    console.log("Service is ready!");
  }

  reactiveCompute(
    _store: SKStore,
    requests: EagerCollection<string, Command>,
    inputCollections: Record<string, EagerCollection<string, TJSON>>,
  ): SimpleServiceOutput {
    const output = requests.map(Request, inputCollections["users"]);
    return { output, update };
  }
}

// Command that starts the service

await runWithServer(new Service(), { port: 8081 });
