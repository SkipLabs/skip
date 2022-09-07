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

CREATE TABLE skdb_objects(objectID INTEGER PRIMARY KEY, tableName STRING, skdb_privacy INTEGER);
CREATE TABLE skdb_arrows(startID INTEGER PRIMARY KEY, endID INTEGER, skdb_privacy INTEGER);
CREATE TABLE skdb_roots(rootID INTEGER PRIMARY KEY, skdb_privacy INTEGER);

