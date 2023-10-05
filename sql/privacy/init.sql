-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_users(
  userUUID STRING PRIMARY KEY,
  privateKey STRING NOT NULL
);

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_user_permissions(
  userUUID STRING PRIMARY KEY,
  permissions INTEGER NOT NULL
);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_group_permissions(
  groupUUID STRING NOT NULL,
  userUUID STRING,
  permissions INTEGER NOT NULL
);

CREATE UNIQUE INDEX skdb_group_permissions_index on
  skdb_group_permissions(groupUUID, userUUID)
;

CREATE VIRTUAL VIEW skdb_groups_users as
  SELECT userUUID as groupUUID from skdb_users UNION ALL
  SELECT groupUUID from skdb_group_permissions GROUP BY groupUUID
;

CREATE UNIQUE INDEX skdb_groups_users_unique ON skdb_groups_users(groupUUID);
