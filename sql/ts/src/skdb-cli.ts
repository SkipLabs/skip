#!/usr/bin/env node

import { parseArgs } from "util";
import * as fs from "fs";
import * as os from "os";
import * as path from "path";
import { createSkdb } from "#skdb/skdb";
import { webcrypto } from "crypto";
import * as readline from "readline/promises";
import * as process from "process";
import * as repl from "repl";

const createConnectedSkdb = async function (
  endpoint,
  database,
  { accessKey, privateKey },
) {
  const skdb = await createSkdb({ asWorker: false });
  const keyBytes = Buffer.from(privateKey, "base64");
  const key = await webcrypto.subtle.importKey(
    "raw",
    keyBytes,
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"],
  );

  await skdb.connect(database, accessKey, key, endpoint);

  return skdb;
};

async function getCredsFromDevServer(
  host: string,
  port: number,
  database: string,
) {
  const creds = new Map();
  try {
    const resp = await fetch(`http://${host}:${port}/dbs/${database}/users`);
    const data = await resp.text();
    const users = data
      .split("\n")
      .filter((line) => line.trim() != "")
      .map((line) => JSON.parse(line));
    for (const user of users) {
      creds.set(user.accessKey, user.privateKey);
    }
  } catch (ex: any) {
    console.log(
      "Could not fetch from the dev server, is it running? Trying because `--dev` was passed.",
    );
    process.exit(1);
  }

  return Object.fromEntries(creds);
}

const skdbDir = path.join(os.homedir(), ".skdb");
const credsFileName = path.join(skdbDir, "credentials");

type Cmd = {
  type: string;
  valName: string;
  default: boolean;
  help: string;
};

const argSchema = {
  help: {
    type: "boolean",
    default: false,
    help: "",
  },
  // connection params
  db: {
    type: "string",
    valName: "db",
    help: "Name of database to connect to.",
  },
  host: {
    type: "string",
    valName: "host",
    help: "URI to connect to.",
    default: "wss://api.skiplabs.io",
  },
  "access-key": {
    type: "string",
    valName: "key",
    help: "Access key to use. Default: first specified in credentials file.",
  },
  dev: {
    type: "boolean",
    help: `Connect to the local dev server, use this to access credentials.`,
    default: false,
  },
  // formatting
  "json-output": {
    type: "boolean",
    help: "Rows are output as JSON objects. Default: false.",
    default: false,
  },
  "pipe-separated-output": {
    type: "boolean",
    help: "SQL output is separated by a pipe. Default: false.",
    default: false,
  },
  "simple-output": {
    type: "boolean",
    help: "No cute terminal usage. E.g. no readline.",
    default: false,
  },
  // operations
  "add-cred": {
    type: "boolean",
    help: `Add a credential to ${credsFileName}. Pass the private key b64 on stdin.`,
    default: false,
  },
  "create-db": {
    type: "string",
    valName: "db",
    help: "Create database.",
  },
  "create-user": {
    type: "boolean",
    help: "Create user.",
    default: false,
  },
  "remote-repl": {
    type: "boolean",
    help: "Interactively execute SQL queries against the server.",
    default: false,
  },
  "local-repl": {
    type: "boolean",
    help: "Interactively execute SQL queries against a local db.",
    default: false,
  },
  schema: {
    type: "boolean",
    help: "Dump the database schema as SQL DML.",
    default: false,
  },
  "table-schema": {
    type: "string",
    valName: "table",
    help: "Dump the table schema as SQL DML.",
  },
  "view-schema": {
    type: "string",
    valName: "view",
    help: "Dump the view schema as SQL DML.",
  },
};

const args = parseArgs({
  options: argSchema as any,
  allowPositionals: true,
  tokens: true,
});

const printHelp = function () {
  const thisBin = process.argv[1];

  const flags = Object.entries(argSchema)
    .map(([key, def]) => {
      const val = def.type === "string" ? ` <${(def as Cmd).valName}>` : "";
      const help = def.help ? `  -- ${def.help}` : "";
      const deflt = (def as Cmd).default
        ? ` Default: ${(def as Cmd).default}`
        : "";
      return `[--${key}${val}]${help}${deflt}`;
    })
    .join("\n    ");

  console.log(`Usage: ${thisBin} ${flags}`);
  console.log("");
  console.log(
    "Anything passed on stdin will be evaluated as sql by the remote db.",
  );
};

const haveMandatoryValues = ["db", "host"].every((flag) => flag in args.values);

if ((args.values as any).help || !haveMandatoryValues) {
  printHelp();
  process.exit(1);
}

let values = args.values as any;

let creds: any;
let hostCreds: any;
let dbCreds: any;

if (args.values["dev"]) {
  if (args.values["add-cred"]) {
    console.log(
      "Cannot add-cred when credentials are managed by the dev server (--dev was passed).",
    );
  }

  let host: string = args.values["host"];
  if (host === "wss://api.skiplabs.io") {
    host = "ws://localhost:3586";
    values.host = host;
  }

  const schemeAndRest = host.split("://", 2);
  const hostAndPort = schemeAndRest[schemeAndRest.length - 1].split(":", 2);

  if (hostAndPort.length < 1) {
    console.log("Invalid host");
    process.exit(1);
  } else if (hostAndPort.length === 1) {
    dbCreds = await getCredsFromDevServer(hostAndPort[0], 3586, values.db);
  } else {
    dbCreds = await getCredsFromDevServer(
      hostAndPort[0],
      parseInt(hostAndPort[1]),
      values.db,
    );
  }
} else {
  // using the local `credsFileName` file

  if (!fs.existsSync(credsFileName)) {
    fs.mkdirSync(skdbDir, { recursive: true });
    fs.writeFileSync(credsFileName, JSON.stringify({}));
  }

  // credentials file schema:
  // {host: { database: { accessKey: privateKey }}}
  creds = JSON.parse(fs.readFileSync(credsFileName).toString());
  hostCreds = creds[values.host as string] ?? {};
  creds[values.host as string] = hostCreds;
  dbCreds = hostCreds[values.db as string] ?? {};
  hostCreds[values.db as string] = dbCreds;

  if (args.values["add-cred"]) {
    if (!("access-key" in args.values)) {
      console.log("Must pass --db --host and --access-key.");
      process.exit(1);
    }

    const accessKey = (args.values["access-key"] as string).trim();
    const privateKey = fs.readFileSync(process.stdin.fd, "utf-8").trim();

    dbCreds[accessKey] = privateKey;

    fs.writeFileSync(credsFileName, JSON.stringify(creds));

    process.exit(0);
  }
}

////////////////////////////////////////////////////////////////////////////////
// past here we're connecting to a server
////////////////////////////////////////////////////////////////////////////////

if (!dbCreds || Object.entries(dbCreds).length < 1) {
  console.log(
    `Could not find credentials for ${values.db} in ${credsFileName}`,
  );
  process.exit(1);
}

const firstPair = Object.entries(dbCreds)[0];
const accessKey = (args.values["access-key"] ?? firstPair[0]) as string;
const privateKey = dbCreds[accessKey];

if (!privateKey) {
  console.log(`Could not find private key for access key: ${accessKey}`);
  process.exit(1);
}

const skdb = await createConnectedSkdb(values.host, values.db, {
  accessKey: accessKey,
  privateKey: privateKey,
});

const display = function (rows: Array<any>) {
  if (args.values["json-output"]) {
    const acc: Array<string> = [];
    for (const row of rows) {
      acc.push(JSON.stringify(row));
    }

    console.log(acc.join("\n"));
  } else if (args.values["pipe-separated-output"]) {
    if (rows.length < 1) {
      return;
    }

    const acc: Array<string> = [];
    const keys = Object.keys(rows[0]);

    acc.push(keys.join("|"));

    for (const row of rows) {
      const rowacc: Array<string> = [];
      for (const key of keys) {
        rowacc.push(row[key]);
      }
      acc.push(rowacc.join("|"));
    }

    console.log(acc.join("\n"));
  } else {
    if (rows.length < 1) {
      return;
    }
    console.table(rows);
  }
};

if (args.values["create-db"]) {
  const db = args.values["create-db"] as string;
  const remote = await skdb.connectedRemote();
  const result = await remote!.createDatabase(db);
  // b64 encode
  result.privateKey = Buffer.from(
    String.fromCharCode(...result.privateKey),
    "base64",
  );
  console.log(`Successfully created database: ${db}.`);
  console.log(`Credentials for ${db}: `, result);

  if (!args.values["dev"]) {
    hostCreds[db] = Object.fromEntries([[result.accessKey, result.privateKey]]);
    fs.writeFileSync(credsFileName, JSON.stringify(creds));
    console.log(`Credentials were added to ${credsFileName}.`);
  }
}

if (args.values["create-user"]) {
  const remote = await skdb.connectedRemote();
  const result = await remote!.createUser();
  // b64 encode
  result.privateKey = Buffer.from(
    String.fromCharCode(...result.privateKey),
    "base64",
  );
  console.log("Successfully created user: ", result);

  if (!args.values["dev"]) {
    dbCreds[result.accessKey] = result.privateKey;
    fs.writeFileSync(credsFileName, JSON.stringify(creds));
    console.log(`Credentials were added to ${credsFileName}.`);
  }
}

if (args.values["schema"]) {
  const remote = await skdb.connectedRemote();
  const schema = await remote!.schema();
  console.log(schema.trim());
}

if (args.values["table-schema"]) {
  const remote = await skdb.connectedRemote();
  const schema = await remote!.tableSchema(
    args.values["table-schema"] as string,
  );
  console.log(schema.trim());
}

if (args.values["view-schema"]) {
  const remote = await skdb.connectedRemote();
  const schema = await remote!.viewSchema(args.values["view-schema"] as string);
  console.log(schema.trim());
}

const remoteRepl = async function () {
  const rl = readline.createInterface(
    process.stdin,
    process.stdout,
    undefined,
    !args.values["simple-output"],
  );
  while (true) {
    if (process.stdin.closed) {
      rl.close();
      process.exit(0);
    }
    const query = await rl.question(
      `${accessKey}@${values.host}/${values.db}> `,
    );

    if (query.trim() === ".exit") {
      rl.close();
      process.exit(0);
    }

    if (query.trim() === ".help") {
      console.log("Send input to the server to be executed as a query.");
      console.log(
        "Multi-statement queries should (currently) be combined on a single line.",
      );
      console.log("");
      console.log("Commands begin with '.'");
      console.log("");
      console.log(".help   -- This message.");
      console.log(".exit   -- Exit this repl session.");
      console.log(".local  -- Switch to local repl.");
      console.log(".schema -- Output the schema.");
      console.log(".table-schema <table> -- Output the schema <table>.");
      console.log(".view-schema <view> -- Output the schema for <view>.");
      continue;
    }

    if (query.trim() === ".local") {
      rl.close();
      await localRepl();
      return;
    }

    if (query.trim() === ".schema") {
      try {
        const remote = await skdb.connectedRemote();
        const schema = await remote!.schema();
        console.log(schema);
      } catch (ex) {
        console.error("Could not query schema.");
        console.error(ex);
      }
      continue;
    }

    if (query.startsWith(".table-schema")) {
      const [_, table] = query.split(" ", 2);
      try {
        const remote = await skdb.connectedRemote();
        const schema = await remote!.tableSchema(table);
        console.log(schema);
      } catch {
        console.error(`Could not find schema for ${table}.`);
      }
      continue;
    }

    if (query.startsWith(".view-schema")) {
      const [_, view] = query.split(" ", 2);
      try {
        const remote = await skdb.connectedRemote();
        const schema = await remote!.viewSchema(view);
        console.log(schema);
      } catch {
        console.error(`Could not find schema for ${view}.`);
      }
      continue;
    }

    try {
      const remote = await skdb.connectedRemote();
      const rows = await remote!.exec(query, {});
      display(rows);
    } catch (ex) {
      console.error("Could not eval query. Try `.help`");
      console.error(ex);
    }
  }
};

const localRepl = async function () {
  const rl = readline.createInterface(
    process.stdin,
    process.stdout,
    undefined,
    !args.values["simple-output"],
  );
  while (true) {
    const query = await rl.question(`local> `);

    if (query.trim() === ".exit") {
      rl.close();
      process.exit(0);
    }

    if (query.trim() === ".help") {
      console.log("Evaluate input as a SQL query against a local database.");
      console.log("");
      console.log("Commands begin with '.'");
      console.log("");
      console.log(".help -- This message.");
      console.log(".exit -- Exit this repl session.");
      console.log(".remote -- Switch to remote repl.");
      console.log(
        ".js -- Switch to a javascript repl. There is a pre-configured `skdb` global. Currently this is a one-way trip.",
      );
      console.log(".schema -- Output the schema.");
      console.log(".table-schema <table> -- Output the schema <table>.");
      console.log(".view-schema <view> -- Output the schema for <view>.");
      console.log(".mirror <table1> <table2> ... -- Mirror the remote tables.");
      continue;
    }

    if (query.trim() === ".remote") {
      rl.close();
      await remoteRepl();
      return;
    }

    if (query.trim() === ".js") {
      rl.close();
      const replServer = repl.start({
        terminal: !args.values["simple-output"],
      });
      replServer.context.skdb = skdb;
      return;
    }

    if (query.trim() === ".schema") {
      try {
        const schema = await skdb.schema();
        console.log(schema);
      } catch (ex) {
        console.error("Could not query schema.");
        console.error(ex);
      }
      continue;
    }

    if (query.startsWith(".table-schema")) {
      const [_, table] = query.split(" ", 2);
      try {
        const schema = await skdb.schema(table);
        console.log(schema);
      } catch {
        console.error(`Could not find schema for ${table}.`);
      }
      continue;
    }

    if (query.startsWith(".view-schema")) {
      const [_, view] = query.split(" ", 2);
      try {
        const schema = await skdb.schema(view);
        console.log(schema);
      } catch {
        console.error(`Could not find schema for ${view}.`);
      }
      continue;
    }

    if (query.startsWith(".mirror")) {
      const args = query.split(" ");
      const tables = args.slice(1);
      try {
        await skdb.mirror(...tables);
      } catch (ex) {
        console.error(`Could not mirror tables ${tables}.`);
        console.error(ex);
      }
      continue;
    }

    try {
      const rows = await skdb.exec(query, {});
      display(rows);
    } catch (ex) {
      console.error("Could not eval query. Try `.help`");
      console.error(ex);
    }
  }
};

if (args.values["remote-repl"]) {
  await remoteRepl();
}

if (args.values["local-repl"]) {
  await localRepl();
}

let query = "";
try {
  query = fs.readFileSync(process.stdin.fd, "utf-8");
} catch {}

if (query.trim() !== "") {
  try {
    const remote = await skdb.connectedRemote();
    const rows = await remote!.exec(query, {});
    display(rows);
  } catch (ex) {
    console.error("Could not eval query.");
    console.error(ex);
    process.exit(1);
  }
}

// we don't close if we've created an interactive session.
// interactively, you can drop to the js console and the control flow
// ends up calling this, which you don't want. the user is going to
// send an interrupt anyway to get out of the shell.
if (!(args.values["remote-repl"] || args.values["local-repl"])) {
  await skdb.closeConnection();
}
