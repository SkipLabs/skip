import { SKDB, SKDBGroup } from "#skdb/skdb_types";

export class SKDBGroupImpl implements SKDBGroup {
  skdb: SKDB;
  ownerGroupID: string;
  adminGroupID: string;
  groupID: string;

  constructor(
    skdb: SKDB,
    groupID: string,
    adminGroupID?: string,
    ownerGroupID?: string,
  ) {
    this.skdb = skdb;
    this.groupID = groupID;
    this.adminGroupID = adminGroupID ?? "admin-" + groupID;
    this.ownerGroupID = ownerGroupID ?? "owner-" + groupID;
  }

  static async lookup(
    skdb: SKDB,
    groupID: string,
  ): Promise<SKDBGroup | undefined> {
    try {
      const adminID = (
        await skdb.exec(
          "SELECT adminID FROM skdb_groups WHERE groupID=@groupID",
          {
            groupID,
          },
        )
      ).scalarValue();
      const ownerID = (
        await skdb.exec(
          "SELECT adminID FROM skdb_groups WHERE groupID=@adminID",
          {
            adminID,
          },
        )
      ).scalarValue();
      return new SKDBGroupImpl(skdb, groupID, adminID, ownerID);
    } catch {}
    return undefined;
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

    const group = new SKDBGroupImpl(skdb, groupID);

    const adminGroupID = group.adminGroupID;
    const ownerGroupID = group.ownerGroupID;

    // set up Admin and Owner groups, also accessed/managed by userID exclusively for now

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

    return group;
  }

  async setDefaultPermission(perm: string) {
    await this.skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES (@groupID, NULL, skdb_permission(@perm), @adminGroupID);",
      { groupID: this.groupID, perm, adminGroupID: this.adminGroupID },
    );
  }
  async setMemberPermission(userID: string, perm: string) {
    await this.skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES (@groupID, @userID, skdb_permission(@perm), 'read-write');",
      { groupID: this.groupID, userID, perm, adminGroupID: this.adminGroupID },
    );
  }

  async removeMember(userID: string) {
    await this.skdb.exec(
      "DELETE FROM skdb_group_permissions WHERE groupID=@groupID AND userID=@userID;",
      { userID, groupID: this.groupID },
    );
  }

  async addAdmin(userID: string) {
    await this.skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES (@adminGroupID, @userID, skdb_permission('rw'), @adminGroupID);",
      {
        userID,
        adminGroupID: this.adminGroupID,
        ownerGroupID: this.ownerGroupID,
      },
    );
  }

  async removeAdmin(userID: string) {
    await this.skdb.exec(
      "DELETE FROM skdb_group_permissions WHERE groupID=@adminGroupID AND userID=@userID;",
      { userID, adminGroupID: this.adminGroupID },
    );
  }

  async addOwner(userID: string) {
    await this.skdb.exec(
      "INSERT OR REPLACE INTO skdb_group_permissions VALUES (@ownerGroupID, @userID, skdb_permission('rw'), @ownerGroupID)",
      { userID, ownerGroupID: this.ownerGroupID },
    );
  }
  async removeOwner(userID: string) {
    await this.skdb.exec(
      "DELETE FROM skdb_group_permissions WHERE groupID=@ownerGroupID AND userID=@userID;",
      { userID, ownerGroupID: this.ownerGroupID },
    );
  }

  async transferOwnership(userID: string) {
    await this.skdb.exec(
      `BEGIN TRANSACTION;
         DELETE FROM skdb_group_permissions WHERE groupID=@ownerGroupID;
         INSERT INTO skdb_group_permissions VALUES (@ownerGroupID, @userID, skdb_permission('rw'), @ownerGroupID);
       COMMIT;`,
      { userID, ownerGroupID: this.ownerGroupID },
    );
  }
}
