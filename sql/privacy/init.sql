-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_users(
  userID STRING PRIMARY KEY,
  privateKey STRING NOT NULL
);

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_user_permissions(
  userID STRING PRIMARY KEY,
  permissions INTEGER NOT NULL,
  skdb_access STRING NOT NULL
);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

-- groupID: which group are we talking about?
-- skdb_author: who is the creator of the group?
-- adminID: who should be able to be admin of the group?
-- skdb_access: who should be able to see/modify the administrators

CREATE TABLE skdb_groups(
  groupID STRING PRIMARY KEY,
  skdb_author STRING,
  adminID STRING NOT NULL,
  skdb_access STRING NOT NULL
);

--- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_group_permissions(
  groupID STRING NOT NULL,
  userID STRING,
  permissions INTEGER NOT NULL,
  skdb_access STRING NOT NULL
);

CREATE UNIQUE INDEX skdb_permissions_group_user ON
  skdb_group_permissions(groupUUID, userUUID)
;

CREATE VIRTUAL VIEW skdb_groups_users AS
  SELECT userID AS groupID FROM skdb_users
  UNION ALL
  SELECT groupID FROM skdb_groups
;

CREATE UNIQUE INDEX skdb_groups_users_unique ON skdb_groups_users(groupID);

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE VIRTUAL VIEW skdb_group_permissions_joined AS
  SELECT
    skdb_group_permissions.groupID,
    skdb_group_permissions.userID,
    skdb_group_permissions.permissions,
    skdb_group_permissions.skdb_access
  FROM skdb_group_permissions, skdb_groups
 WHERE skdb_group_permissions.groupID = skdb_groups.groupID
   AND skdb_group_permissions.skdb_access = skdb_groups.adminID
;

CREATE UNIQUE INDEX skdb_group_permissions_joined_index ON
  skdb_group_permissions_joined(groupID, userID)
;

-------------------------------------------------------------------------------
-- Some default groups
-------------------------------------------------------------------------------

-- First let's create read-only-root, it's a group where everybody can
-- read but nothing else.

INSERT INTO skdb_groups
  VALUES ('read-only-root', NULL, 'root', 'root')
;

INSERT INTO skdb_group_permissions
  VALUES ('read-only-root', NULL, skdb_permission('r'), 'root')
;

-- read-only is visible by everyone, but only the root can change the
-- permissions (which should never happen).

INSERT INTO skdb_groups
  VALUES ('read-only', NULL, 'read-only-root', 'root')
;

INSERT INTO skdb_group_permissions
  VALUES ('read-only', NULL, skdb_permission('r'), 'read-only-root')
;

-- write-only is visible by everyone, but only the root can change the
-- permissions (which should never happen).

INSERT INTO skdb_groups
  VALUES ('write-only', NULL, 'read-only-root', 'root')
;

INSERT INTO skdb_group_permissions
  VALUES ('write-only', NULL, skdb_permission('di'), 'read-only-root')
;

-- read-write is visible by everyone, but only the root can change the
-- permissions (which should never happen).

INSERT INTO skdb_groups
  VALUES ('read-write', NULL, 'read-only-root', 'root')
;

INSERT INTO skdb_group_permissions
  VALUES ('read-write', NULL, skdb_permission('dir'), 'read-only-root')
;
