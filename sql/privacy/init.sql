-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_users(
  userID STRING PRIMARY KEY,
  userName STRING UNIQUE NOT NULL,
  privateKey STRING NOT NULL
);

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_user_permissions(
  userID STRING PRIMARY KEY,
  permissions INTEGER NOT NULL
);

-------------------------------------------------------------------------------
-- Tables permissions
-------------------------------------------------------------------------------

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_table_permissions(
  name STRING PRIMARY KEY,
  permissions INTEGER NOT NULL
);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_group_permissions(
  groupID STRING NOT NULL,
  userID STRING,
  permissions INTEGER NOT NULL
);

CREATE UNIQUE INDEX skdb_group_permissions_index on
  skdb_group_permissions(groupID, userID)
;

CREATE VIRTUAL VIEW skdb_groups_users as
  SELECT userID as groupID from skdb_users UNION ALL
  SELECT groupID from skdb_group_permissions GROUP BY groupID
;

CREATE UNIQUE INDEX skdb_groups_users_unique ON skdb_groups_users(groupID);
