-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

CREATE TABLE skdb_users(userID INTEGER PRIMARY KEY, userName STRING UNIQUE NOT NULL);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

CREATE TABLE skdb_groups(
  groupID INTEGER PRIMARY KEY,
  readers STRING,
  writers STRING,
  groupName STRING
);

-- Passed this point The view skdb_groups_readers is created by the db.
CREATE INDEX skdb_groups_readers_readerID ON skdb_groups_readers(readerID);

CREATE INDEX skdb_groups_groupName ON skdb_groups(groupName);

-- The group of all users
INSERT INTO skdb_groups VALUES (id(), 'skdb_users', 'skdb_users', 'ALL');

-------------------------------------------------------------------------------
-- Graph
-------------------------------------------------------------------------------

CREATE TABLE skdb_objects(
  objectID INTEGER PRIMARY KEY,
  tableName STRING,
  tableObjectID INTEGER,
  skdb_privacy INTEGER
);

CREATE TABLE skdb_arrows(
  startID INTEGER,
  endID INTEGER,
  skdb_privacy INTEGER
);

CREATE TABLE skdb_roots(
  rootID INTEGER PRIMARY KEY,
  start INTEGER NOT NULL,
  depth INTEGER NOT NULL,
  width INTEGER NOT NULL,
  userID INTEGER
);

CREATE TABLE skdb_expanded(
  parentID INTEGER,
  objectID INTEGER
);

