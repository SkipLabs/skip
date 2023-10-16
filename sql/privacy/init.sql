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

-- groupUUID: which group are we talking about?
-- skdb_author: who is the creator of the group?
-- skdb_admin: who should be able to be admin of the group?
-- skdb_access: who should be able to see/modify the administrators

CREATE TABLE skdb_groups(
  groupUUID STRING PRIMARY KEY,
  skdb_author STRING,
  adminUUID STRING NOT NULL,
  skdb_access STRING NOT NULL
);

-- INTERNAL TABLE: DO NOT CHANGE DEFINITION
CREATE TABLE skdb_group_permissions(
  groupUUID STRING NOT NULL,
  userUUID STRING,
  permissions INTEGER NOT NULL,
  skdb_access STRING NOT NULL
);

CREATE VIRTUAL VIEW skdb_groups_users as
  SELECT userUUID as groupUUID from skdb_users UNION ALL
  SELECT groupUUID from skdb_groups GROUP BY groupUUID
;

CREATE UNIQUE INDEX skdb_groups_users_unique ON skdb_groups_users(groupUUID);

CREATE VIRTUAL VIEW skdb_group_permissions_joined AS
  SELECT
    skdb_group_permissions.groupUUID,
    skdb_group_permissions.userUUID,
    skdb_group_permissions.permissions,
    skdb_group_permissions.skdb_access
  FROM skdb_group_permissions, skdb_groups
 WHERE skdb_group_permissions.groupUUID = skdb_groups.groupUUID
   AND skdb_group_permissions.skdb_access = skdb_groups.adminUUID
;

CREATE UNIQUE INDEX skdb_group_permissions_joined_index on
  skdb_group_permissions_joined(groupUUID, userUUID)
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
  VALUES ('read-only-root', NULL, 4, 'root')
;

-- read-only is visible by everyone, but only the root can change the
-- permissions (which should never happen).

INSERT INTO skdb_groups
  VALUES ('read-only', NULL, 'read-only-root', 'root')
;

INSERT INTO skdb_group_permissions
  VALUES ('read-only', NULL, 4, 'read-only-root')
;

-- write-only is visible by everyone, but only the root can change the
-- permissions (which should never happen).

INSERT INTO skdb_groups
  VALUES ('write-only', NULL, 'read-only-root', 'root')
;

INSERT INTO skdb_group_permissions
  VALUES ('write-only', NULL, 3, 'read-only-root')
;

-- read-write is visible by everyone, but only the root can change the
-- permissions (which should never happen).

INSERT INTO skdb_groups
  VALUES ('read-write', NULL, 'read-only-root', 'root')
;

INSERT INTO skdb_group_permissions
  VALUES ('read-write', NULL, 7, 'read-only-root')
;
