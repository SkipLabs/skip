import { run, loadEnv, isNode} from "#std/sk_types";
import { SKDB, SKDBSync, SKDBShared } from "#skdb/skdb_types";
import { SKDBWorker } from "#skdb/skdb_wdatabase";
export { SKDB, RemoteSKDB } from "#skdb/skdb_types";
export { SkdbTable } from "#skdb/skdb_util";
export { Creds, MuxedSocket } from "#skdb/skdb_orchestration";
export { Environment } from "#std/sk_types";

var wasm64 = "skdb";
var modules = [ /*--MODULES--*/];
var extensions = new Map();
/*--EXTENSIONS--*/

export async function createSkdb(options: {
  dbName ?: string,
  asWorker?: boolean,
  getWasmSource?: () => Promise<Uint8Array>
} = {}) : Promise<SKDB> {
  const asWorker = (options.asWorker != undefined) ? options.asWorker : !options.getWasmSource;
  if (!asWorker) {
    return createOnMain(options.dbName, options.getWasmSource);
  } else {
    if (options.getWasmSource) {
      throw new Error("getWasmSource is not compatible with worker")
    }
    return createWorker(options.dbName);
  }
}

async function createSkdbSync(options: {
  dbName ?: string,
  getWasmSource?: () => Promise<Uint8Array>
} = {}) : Promise<SKDBSync> {
  let data = await run(wasm64, modules, extensions, "SKDB_factory", options.getWasmSource);
  return (data.environment.shared.get("SKDB") as SKDBShared).createSync(options.dbName);
}

async function createOnMain(dbName ?: string, getWasmSource?: () => Promise<Uint8Array>) {
  let data = await run(wasm64, modules, extensions, "SKDB_factory", getWasmSource);
  return (data.environment.shared.get("SKDB") as SKDBShared).create(dbName);
}

async function createWorker(dbName ?: string) {
  let env = await loadEnv(extensions);
  let path : string;
  if (isNode()) {
    path = import.meta.url.replace('/skdb.mjs', '/skdb_nodeworker.mjs');
    // @ts-ignore
    path = "./" + path.substring(process.cwd().length + 8);
  } else {
    path = import.meta.url.replace('/skdb.mjs', '/skdb_worker.mjs');
  }
  let worker = env.createWorker(path, {type: 'module'});
  let skdb = new SKDBWorker(worker);
  await skdb.create(dbName);
  return skdb;
}

///////////////////////////////////////////////////////////////////////////////
// Privacy related primitives
///////////////////////////////////////////////////////////////////////////////

class SKDBGroup {
  ownerGroupID: string;
  adminGroupID: string;
  groupID: string;

  constructor(ownerGroupID: string, adminGroupID: string, groupID: string) {
    this.ownerGroupID = ownerGroupID;
    this.adminGroupID = adminGroupID;
    this.groupID = groupID;
  }

  async transfer(skdb: SKDB, userID: string): Promise<void> {
    await skdb.exec(
      "BEGIN TRANSACTION;" +
      "DELETE FROM skdb_group_permissions WHERE groupUUID=@ownerGroupID;" +
      "INSERT INTO skdb_group_permissions VALUES(@ownerGroupID, @userID, 7, @ownerGroupID);" +
      "COMMIT;",
      {ownerGroupID: this.ownerGroupID, userID}
    );
  }

  async addAdmin(skdb: SKDB, userID: string): Promise<void> {
    await skdb.exec(
      "INSERT INTO skdb_group_permissions VALUES(@adminGroupID, @userID, 7, @ownerGroupID);",
      {ownerGroupID: this.ownerGroupID, adminGroupID: this.adminGroupID, userID}
    );
  }

  async setUser(skdb: SKDB, userID: string, permissions: string): Promise<void> {
    await skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES(@groupID, @userID, skdb_permissions(@permissions), @adminGroupID);",
      {groupID: this.groupID, adminGroupID: this.adminGroupID, permissions, userID}
    );
  }
}

export async function createGroup(skdb: SKDB, userID: string, groupID: string): Promise<SKDBGroup> {
  const ownerGroupID = "owner-" + groupID;

  // Creates a new group, the ownership is for the user (for now)
  await skdb.exec(
    "INSERT INTO skdb_groups VALUES(@ownerGroupID, @userID, @userID, @userID);",
    {ownerGroupID, userID}
  );

  // Adds the right for the user in the group
  console.log(await skdb.exec(
    "INSERT INTO skdb_group_permissions VALUES(@ownerGroupID, @userID, 7, @userID);",
    {ownerGroupID, userID}
  ));

  // Passed this point, userID can do anything in the group myAdminGroup

  // Add an entry so that userID would also be admin if the admins of
  // myAdminGroup were to change to myAdminGroup (itself).  This entry is
  // not active because myAdminGroup is still pointing at userID as an
  // admin, but the moment we switch, that will not longer be the case.

  console.log(await skdb.exec("select * skdb_group_permissions"));

  await skdb.exec(
    "INSERT INTO skdb_group_permissions VALUES(@ownerGroupID, @userID, 7, @ownerGroupID);"+
      "INSERT INTO skdb_group_permissions VALUES(@ownerGroupID, NULL, 4, @ownerGroupID);",
    {ownerGroupID, userID}
  );

  // Now let's make the switch! Let's make ownerGroupID use ownerGroupID
  // (itself) as an admin. Note that the delete and the insert have to
  // happen in the same transaction, otherwise we would lose access after
  // the delete.

  await skdb.exec(
    "UPDATE skdb_groups SET adminUUID=@ownerGroupID, skdb_access=@ownerGroupID WHERE groupUUID=@ownerGroupID;",
    {ownerGroupID}
  );

  // Let's clean up after ourselves, this permission is no longer in use

  await skdb.exec(
    "DELETE FROM skdb_group_permissions WHERE groupUUID=@ownerGroupID AND skdb_access=@userID;",
    {ownerGroupID, userID}
  );

  let adminGroupID = "admin-" + groupID;

  // Let's create an admin group
  await skdb.exec(    
    "INSERT INTO skdb_groups VALUES (@adminGroupID, @userID, @ownerGroupID, @ownerGroupID);",
    {ownerGroupID, adminGroupID, userID}
  );

  // Now let's add the owner to the admin group
  await skdb.exec(
    "INSERT INTO skdb_group_permissions VALUES(@adminGroupID, @userID, 7, @ownerGroupID);" +
      "INSERT INTO skdb_group_permissions VALUES(@adminGroupID, NULL, 4, @ownerGroupID);",
    {ownerGroupID, adminGroupID, userID}
  );

  // Finally, let's create the group
  await skdb.exec(
    "INSERT INTO skdb_groups VALUES (@groupID, @userID, @adminGroupID, @adminGroupID);",
    {groupID, adminGroupID, userID}
  );

  return new SKDBGroup(ownerGroupID, adminGroupID, groupID);
}
