import { parseArgs } from "node:util";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import SKDB from "./skdb_node.js";
import { webcrypto } from 'node:crypto';

const createConnectedSkdb = async function(endpoint, database, { accessKey, privateKey }) {
  const skdb = await SKDB.create(true);

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
  db: {
    type: "string",
    help: "Name of database to connect to."
  },
  host: {
    type: "string",
    help: "URI to connect to.",
    default: "wss://api.skiplabs.io",
  },
  'access-key': {
    type: "string",
    help: "Access key to use. Default: first specified in credentials file.",
  },
  'create-db': {
    type: "string",
    help: "Create database.",
  },
  'create-user': {
    type: "boolean",
    help: "Create user.",
    default: false,
  }
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
          const val = def.type === "string" ? ` <${key}>` : '';
          const help = def.help ? `  -- ${def.help}` : '';
          const deflt = def.default ? ` Default: ${def.default}`: '';
          return `[--${key}${val}]${help}${deflt}`;
        })
        .join('\n    ');

  console.log(`Usage: ${thisBin} ${flags}`);
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
// { database: { accessKey: privateKey }}
const creds = JSON.parse(fs.readFileSync(credsFileName));
const dbCreds = creds[args.values.db];

if (!dbCreds || Object.entries(dbCreds).length < 1) {
  console.log(`Could not find credentials for ${args.values.db} in ${credsFileName}`);
  process.exit(1);
}

const firstPair = Object.entries(dbCreds)[0];
const accessKey = args.values['access-key'] ?? firstPair[0];
const privateKey = args.values['private-key'] ?? firstPair[1];

const skdb = await createConnectedSkdb(args.values.host, args.values.db, {
  accessKey: accessKey,
  privateKey: privateKey,
});

if (args.values['create-db']) {
  const db = args.values['create-db'];
  const result = await skdb.server().createDatabase(db);
  console.log(`Successfully created database: ${db}.`);
  console.log(`Credentials for ${db}: `, result);

  creds[db] = Object.fromEntries([[result.accessKey, result.privateKey]]);
  fs.writeFileSync(credsFileName, JSON.stringify(creds));
  console.log(`Credentials were added to ${credsFileName}.`);
}

if (args.values['create-user']) {
  const result = await skdb.server().createUser();
  console.log('Successfully created user: ', result);

  dbCreds[result.accessKey] = result.privateKey;

  fs.writeFileSync(credsFileName, JSON.stringify(creds));
  console.log(`Credentials were added to ${credsFileName}.`);
}
