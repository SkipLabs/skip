-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_users(
  userName STRING PRIMARY KEY,
  privateKey STRING NOT NULL
);

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_user_permissions(
  userName STRING PRIMARY KEY,
  permissions INTEGER NOT NULL
);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_group_permissions(
  groupName STRING NOT NULL,
  userName STRING,
  permissions INTEGER NOT NULL
);

CREATE UNIQUE INDEX skdb_group_permissions_index on
  skdb_group_permissions(groupName, userName)
;

CREATE VIRTUAL VIEW skdb_groups_users as
  SELECT userName as groupName from skdb_users UNION ALL
  SELECT groupName from skdb_group_permissions GROUP BY groupName
;

CREATE UNIQUE INDEX skdb_groups_users_unique ON skdb_groups_users(groupName);
