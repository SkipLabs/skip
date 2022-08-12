-------------------------------------------------------------------------------
-- Users and active users
-------------------------------------------------------------------------------

CREATE TABLE skdb_users(userID INTEGER PRIMARY KEY, userName STRING UNIQUE NOT NULL);

CREATE TABLE skdb_active_users(userID INTEGER UNIQUE NOT NULL);

CREATE VIRTUAL VIEW skdb_active_users_view AS
  SELECT *
  FROM
    skdb_users AS u,
    skdb_active_users AS au
  WHERE u.userID = au.userID
;

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

CREATE INDEX skdb_groups_groupName ON skdb_groups(groupName);

-- The group of all users
INSERT INTO skdb_groups VALUES (id(), 'skdb_users', 'skdb_users', 'ALL');

CREATE VIRTUAL VIEW skdb_groups_active_readers AS
  SELECT DISTINCT groupID, readerID
  FROM
    skdb_groups_readers,
    skdb_active_users
  WHERE readerID = userID
;

-------------------------------------------------------------------------------
-- The graph of objects.
-------------------------------------------------------------------------------

CREATE TABLE skdb_objects(objectID INTEGER PRIMARY KEY, tableName STRING, skdb_privacy INTEGER);
CREATE TABLE skdb_arrows(startID INTEGER PRIMARY KEY, endID INTEGER, skdb_privacy INTEGER);
CREATE TABLE skdb_roots(rootID INTEGER PRIMARY KEY, skdb_privacy INTEGER);
CREATE TABLE skdb_pointers(rootID INTEGER PRIMARY KEY, skdb_privacy INTEGER);


   
