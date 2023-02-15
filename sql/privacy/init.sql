-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

CREATE TABLE skdb_users(
  userID INTEGER PRIMARY KEY,
  username STRING UNIQUE NOT NULL,
  privateKey STRING NOT NULL
);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

CREATE TABLE skdb_groups(
  groupID INTEGER PRIMARY KEY,
  members STRING NOT NULL
);

-- Passed this point The view skdb_groups_members is created by the db.
CREATE INDEX skdb_groups_index ON skdb_groups(members);
CREATE INDEX skdb_groups_members_memberID ON skdb_groups_members(memberID);

CREATE TABLE whitelist_noone(userID INTEGER);
CREATE TABLE blacklist_noone(userID INTEGER);

INSERT INTO skdb_groups VALUES (1, 'whitelist_noone');
INSERT INTO skdb_groups VALUES (-1, 'blacklist_noone');

-------------------------------------------------------------------------------
-- Access
-------------------------------------------------------------------------------

CREATE TABLE skdb_access(
  accessID INTEGER PRIMARY KEY,
  readersID INTEGER NOT NULL,
  writersID INTEGER NOT NULL,
  name STRING UNIQUE
);

CREATE VIRTUAL VIEW skdb_access_readers AS SELECT
  accessID INTEGER,
  memberID INTEGER
FROM skdb_access, skdb_groups_members
WHERE readersID = groupID
;

CREATE VIRTUAL VIEW skdb_access_writers AS SELECT
  accessID INTEGER,
  memberID INTEGER
FROM skdb_access, skdb_groups_members
WHERE writersID = groupID
;

INSERT INTO skdb_access VALUES (-1, -1, -1, 'everyone');
