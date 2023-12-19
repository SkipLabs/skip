import { SKDB, SKDBGroup } from "#skdb/skdb_types";

export class SKDBGroupImpl implements SKDBGroup {
  ownerGroupID: string;
  adminGroupID: string;
  groupID: string;

  constructor(groupID: string, adminGroupID: string, ownerGroupID: string) {
    this.groupID = groupID;
    this.adminGroupID = adminGroupID;
    this.ownerGroupID = ownerGroupID;
  }

  static async create(skdb: SKDB): Promise<SKDBGroup> {
    const userID = skdb.currentUser!;

    // First, create the primary group and get its auto-generated groupID
    // (initially managed/accessed exclusively by userID, since we haven't created admin/owner groups yet)
    const groupID = (
      await skdb.exec(
        `BEGIN TRANSACTION;
           INSERT INTO skdb_groups VALUES (id('groupID'), @userID, @userID, @userID);
           SELECT id('groupID');
         COMMIT;`,
        { userID },
      )
    ).scalarValue();

    // set up Admin and Owner groups, also accessed/managed by userID exclusively for now
    const adminGroupID = "admin-" + groupID;
    const ownerGroupID = "owner-" + groupID;

    await skdb.exec(
      "INSERT INTO skdb_groups VALUES (@ownerGroupID, @userID, @userID, @userID);" +
        "INSERT INTO skdb_group_permissions VALUES (@ownerGroupID, @userID, skdb_permission('rw'), @userID);",
      { ownerGroupID, userID },
    );

    await skdb.exec(
      "INSERT INTO skdb_groups VALUES (@adminGroupID, @userID, @ownerGroupID, @userID);" +
        "INSERT INTO skdb_group_permissions VALUES (@adminGroupID, @userID, skdb_permission('rw'), @ownerGroupID);",
      { adminGroupID, userID, ownerGroupID },
    );

    // Now that Admin and Owner groups are set up, add userID to the Primary group
    // and set all of the admin/access fields of the groups properly.
    await skdb.exec(
      "INSERT INTO skdb_group_permissions VALUES (@groupID, @userID, skdb_permission('rw'), 'read-write');",
      { groupID, userID, adminGroupID },
    );

    await skdb.exec(
      "UPDATE skdb_groups SET skdb_access='read-write', adminID=@adminGroupID WHERE groupID=@groupID;",
      { groupID, adminGroupID },
    );
    await skdb.exec(
      "UPDATE skdb_groups SET skdb_access=@adminGroupID WHERE groupID=@adminGroupID;" +
        "UPDATE skdb_group_permissions SET skdb_access=@adminGroupID WHERE groupID=@adminGroupID;",
      { adminGroupID },
    );
    await skdb.exec(
      "UPDATE skdb_groups SET skdb_access=@ownerGroupID, adminID=@ownerGroupID WHERE groupID=@ownerGroupID;",
      { ownerGroupID },
    );

    return new SKDBGroupImpl(groupID, adminGroupID, ownerGroupID);
  }

  async setDefaultPermission(skdb: SKDB, perm: string) {
    await skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES (@groupID, NULL, skdb_permission(@perm), @adminGroupID);",
      { groupID: this.groupID, perm, adminGroupID: this.adminGroupID },
    );
  }
  async setMemberPermission(skdb: SKDB, userID: string, perm: string) {
    await skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES (@groupID, @userID, skdb_permission(@perm), 'read-write');",
      { groupID: this.groupID, userID, perm, adminGroupID: this.adminGroupID },
    );
  }

  async removeMember(skdb: SKDB, userID: string) {
    await skdb.exec(
      "DELETE FROM skdb_group_permissions WHERE groupID=@groupID AND userID=@userID;",
      { userID, groupID: this.groupID },
    );
  }

  async addAdmin(skdb: SKDB, userID: string) {
    await skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES (@adminGroupID, @userID, skdb_permission('rw'), @adminGroupID);",
      {
        userID,
        adminGroupID: this.adminGroupID,
        ownerGroupID: this.ownerGroupID,
      },
    );
  }

  async removeAdmin(skdb: SKDB, userID: string) {
    await skdb.exec(
      "DELETE FROM skdb_group_permissions WHERE groupID=@adminGroupID AND userID=@userID;",
      { userID, adminGroupID: this.adminGroupID },
    );
  }

  async addOwner(skdb: SKDB, userID: string) {
    await skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES (@ownerGroupID, @userID, skdb_permission('rw'), @ownerGroupID)",
      { userID, ownerGroupID: this.ownerGroupID },
    );
  }
  async removeOwner(skdb: SKDB, userID: string) {
    await skdb.exec(
      "DELETE FROM skdb_group_permissions WHERE groupID=@ownerGroupID AND userID=@userID;",
      { userID, ownerGroupID: this.ownerGroupID },
    );
  }

  async transferOwnership(skdb: SKDB, userID: string) {
    await skdb.exec(
      `BEGIN TRANSACTION;
         DELETE FROM skdb_group_permissions WHERE groupID=@ownerGroupID;
         INSERT INTO skdb_group_permissions VALUES (@ownerGroupID, @userID, skdb_permission('rw'), @ownerGroupID);
       COMMIT;`,
      { userID, ownerGroupID: this.ownerGroupID },
    );
  }
}
