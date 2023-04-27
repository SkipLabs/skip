#!/usr/bin/env node

import { parseArgs } from "node:util";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { SKDB, fetchWasmSource } from "skdb";
import { webcrypto } from 'node:crypto';
import * as readline from 'node:readline/promises';
import process from 'node:process';
import repl from 'node:repl';

const createConnectedSkdb = async function(endpoint, database, { accessKey, privateKey }) {
  const skdb = await SKDB.create(null, fetchWasmSource);

  const keyBytes = Uint8Array.from(atob(privateKey), c => c.charCodeAt(0));

  const key = await webcrypto.subtle.importKey(
    "raw", keyBytes, { name: "HMAC", hash: "SHA-256"}, false, ["sign"]);

  await skdb.connect(database, accessKey, key, endpoint);

  return skdb;
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
    valName: 'db',
    help: "Name of database to connect to."
  },
  host: {
    type: "string",
    valName: 'host',
    help: "URI to connect to.",
    default: "wss://api.skiplabs.io",
  },
  'access-key': {
    type: "string",
    valName: 'key',
    help: "Access key to use. Default: first specified in credentials file.",
  },
  // formatting
  'pipe-separated-output': {
    type: "boolean",
    help: "SQL output is separated by a pipe. Default: JSON output.",
    default: false,
  },
  'simple-output': {
    type: "boolean",
    help: "No cute terminal usage. E.g. no readline.",
    default: false,
  },
  // operations
  'create-db': {
    type: "string",
    valName: 'db',
    help: "Create database.",
  },
  'create-user': {
    type: "boolean",
    help: "Create user.",
    default: false,
  },
  'remote-repl': {
    type: "boolean",
    help: "Interactively execute SQL queries against the server.",
    default: false,
  },
  'local-repl': {
    type: "boolean",
    help: "Interactively execute SQL queries against a local db.",
    default: false,
  },
  'schema': {
    type: "boolean",
    help: "Dump the database schema as SQL DML.",
    default: false,
  },
  'table-schema': {
    type: "string",
    valName: 'table',
    help: "Dump the table schema as SQL DML.",
  },
  'view-schema': {
    type: "string",
    valName: 'view',
    help: "Dump the view schema as SQL DML.",
  },
};

const args = parseArgs({
  options: argSchema,
  allowPositionals: true,
  tokens: true,
});

const printHelp = function() {
  const thisBin = process.argv[1];

  const flags = Object.entries(argSchema)
        .map(([key, def]) => {
          const val = def.type === "string" ? ` <${def.valName}>` : '';
          const help = def.help ? `  -- ${def.help}` : '';
          const deflt = def.default ? ` Default: ${def.default}`: '';
          return `[--${key}${val}]${help}${deflt}`;
        })
        .join('\n    ');

  console.log(`Usage: ${thisBin} ${flags}`);
  console.log("");
  console.log("Anything passed on stdin will be evaluated as sql by the remote db.");
};

const haveMandatoryValues = ['db', 'host']
      .every(flag => flag in args.values);

if (args.values.help || !haveMandatoryValues) {
  printHelp();
  process.exit(1);
}

const credsFileName = path.join(os.homedir(), ".skdb", "credentials");

if (!fs.existsSync(credsFileName)) {
  console.log(`Could not find credentials file at ${credsFileName}`);
  process.exit(1);
}

// credentials file schema:
// {host: { database: { accessKey: privateKey }}}
const creds = JSON.parse(fs.readFileSync(credsFileName));
const hostCreds = creds[args.values.host] ?? {};
const dbCreds = hostCreds[args.values.db];

if (!dbCreds || Object.entries(dbCreds).length < 1) {
  console.log(`Could not find credentials for ${args.values.db} in ${credsFileName}`);
  process.exit(1);
}

const firstPair = Object.entries(dbCreds)[0];
const accessKey = args.values['access-key'] ?? firstPair[0];
const privateKey = dbCreds[accessKey];

const skdb = await createConnectedSkdb(args.values.host, args.values.db, {
  accessKey: accessKey,
  privateKey: privateKey,
});

const evalQuery = async function(skdb_client, query) {
  if (args.values['pipe-separated-output']) {
    let answer = await skdb_client.sqlRaw(query);
    answer = answer.trim();
    return answer;
  } else {
    return skdb_client.sql(query);
  }
};

if (args.values['create-db']) {
  const db = args.values['create-db'];
  const result = await skdb.server.createDatabase(db);
  console.log(`Successfully created database: ${db}.`);
  console.log(`Credentials for ${db}: `, result);

  hostCreds[db] = Object.fromEntries([[result.accessKey, result.privateKey]]);
  fs.writeFileSync(credsFileName, JSON.stringify(creds));
  console.log(`Credentials were added to ${credsFileName}.`);
}

if (args.values['create-user']) {
  const result = await skdb.server.createUser();
  console.log('Successfully created user: ', result);

  dbCreds[result.accessKey] = result.privateKey;
  fs.writeFileSync(credsFileName, JSON.stringify(creds));
  console.log(`Credentials were added to ${credsFileName}.`);
}

if (args.values['schema']) {
  const schema = await skdb.server.schema();
  console.log(schema.trim());
}

if (args.values['table-schema']) {
  const schema = await skdb.server.tableSchema(args.values['table-schema']);
  console.log(schema.trim());
}

if (args.values['view-schema']) {
  const schema = await skdb.server.viewSchema(args.values['view-schema']);
  console.log(schema.trim());
}

const remoteRepl = async function() {
  const rl = readline.createInterface(process.stdin, process.stdout, undefined,
                                      !args.values['simple-output']);
  while (true) {
    const query = await rl.question(`${accessKey}@${args.values.host}/${args.values.db}> `);

    if (query.trim() === '.help') {
      console.log("Send input to the server to be executed as a query.");
      console.log("Multi-statement queries should (currently) be combined on a single line.");
      console.log("");
      console.log("Commands begin with '.'");
      console.log("");
      console.log(".help   -- This message.");
      console.log(".local -- Switch to local repl.");
      console.log(".schema -- Output the schema.");
      console.log(".table-schema <table> -- Output the schema <table>.");
      console.log(".view-schema <view> -- Output the schema for <view>.");
      continue;
    }

    if (query.trim() === '.local') {
      rl.close();
      await localRepl();
      return;
    }

    if (query.trim() === '.schema') {
      const schema = await skdb.server.schema();
      console.log(schema);
      continue;
    }

    if (query.startsWith('.table-schema')) {
      const [_, table] = query.split(" ", 2);
      try {
        const schema = await skdb.server.tableSchema(table);
        console.log(schema);
      } catch {
        console.error(`Could not find schema for ${table}.`);
      }
      continue;
    }

    if (query.startsWith('.view-schema')) {
      const [_, view] = query.split(" ", 2);
      try {
        const schema = await skdb.server.viewSchema(view);
        console.log(schema);
      } catch {
        console.error(`Could not find schema for ${view}.`);
      }
      continue;
    }

    try {
      const answer = await evalQuery(skdb.server, query);
      console.log(answer);
    } catch (ex) {
      console.error("Could not eval query. Try `.help`");
      // TODO: this currently contains no information. we need to add errors to the protocol
      // console.error(ex);
    }
  }
};

const localRepl = async function() {
  const rl = readline.createInterface(process.stdin, process.stdout, undefined,
                                      !args.values['simple-output']);
  while (true) {
    const query = await rl.question(`local> `);

    if (query.trim() === '.help') {
      console.log("Evaluate input as a SQL query against a local database.");
      console.log("");
      console.log("Commands begin with '.'");
      console.log("");
      console.log(".help -- This message.");
      console.log(".remote -- Switch to remote repl.");
      console.log(".js -- Switch to a javascript repl. There is a pre-configured `skdb` global. Currently this is a one-way trip.");
      console.log(".schema -- Output the schema.");
      console.log(".table-schema <table> -- Output the schema <table>.");
      console.log(".view-schema <view> -- Output the schema for <view>.");
      console.log(".mirror-table <table> -- Mirror the remote table <table>.");
      console.log(".mirror-view <view> -- Mirror the remote view <view>.");
      continue;
    }

    if (query.trim() === '.remote') {
      rl.close();
      await remoteRepl();
      return;
    }

    if (query.trim() === '.js') {
      rl.close();
      const replServer = repl.start({
        terminal: !args.values['simple-output'],
      });
      replServer.context.skdb = skdb;
      return;
    }

    if (query.trim() === '.schema') {
      const schema = skdb.schema();
      console.log(schema);
      continue;
    }

    if (query.startsWith('.table-schema')) {
      const [_, table] = query.split(" ", 2);
      try {
        const schema = skdb.tableSchema(table);
        console.log(schema);
      } catch {
        console.error(`Could not find schema for ${table}.`);
      }
      continue;
    }

    if (query.startsWith('.view-schema')) {
      const [_, view] = query.split(" ", 2);
      try {
        const schema = skdb.viewSchema(view);
        console.log(schema);
      } catch {
        console.error(`Could not find schema for ${view}.`);
      }
      continue;
    }

    if (query.startsWith('.mirror-table')) {
      const [_, table] = query.split(" ", 2);
      try {
        await skdb.server.mirrorTable(table);
      } catch {
        console.error(`Could not mirror table ${table}.`);
      }
      continue;
    }

    if (query.startsWith('.mirror-view')) {
      const [_, view] = query.split(" ", 2);
      try {
        await skdb.server.mirrorView(view);
      } catch {
        console.error(`Could not mirror view ${view}.`);
      }
      continue;
    }

    try {
      const answer = await evalQuery(skdb, query);
      console.log(answer);
    } catch (ex) {
      console.error("Could not eval query. Try `.help`");
      // TODO: this currently contains no information. we need to add errors to the protocol
      // console.error(ex);
    }
  }
};

if (args.values['remote-repl']) {
  await remoteRepl();
}

if (args.values['local-repl']) {
  await localRepl();
}

let query = "";
try {
  query = fs.readFileSync(process.stdin.fd, 'utf-8');
} catch {}

if (query.trim() !== "") {
  try {
    const answer = await evalQuery(skdb.server, query);
    console.log(answer);
  } catch (ex) {
    console.error("Could not eval query.");
    process.exit(1);
    // TODO: this currently contains no information. we need to add errors to the protocol
    // console.error(ex);
  }
}

skdb.server?.close();
