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
  skdb_group_permissions(groupID, userID)
;

CREATE VIRTUAL VIEW skdb_groups_users AS
  SELECT userID AS groupID FROM skdb_users
  UNION ALL
  SELECT groupID FROM skdb_groups
;

CREATE UNIQUE INDEX skdb_groups_users_unique ON skdb_groups_users(groupID);

-------------------------------------------------------------------------------
-- Some default groups
-- (globally-visible) groups granting global privileges matching their groupID
-------------------------------------------------------------------------------

INSERT INTO skdb_groups VALUES
  ('read-only', NULL, 'root', 'read-only'),
  ('read-write', NULL, 'root', 'read-only'),
  ('write-only', NULL, 'root', 'read-only')
;

INSERT INTO skdb_group_permissions VALUES
       ('read-only', NULL, skdb_permission('r'), 'read-only'),
       ('write-only', NULL, skdb_permission('w'), 'read-only'),
       ('read-write', NULL, skdb_permission('rw'), 'read-only')
;
