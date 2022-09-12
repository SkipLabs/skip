-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

CREATE TABLE skdb_users(
  userID INTEGER PRIMARY KEY,
  userName STRING UNIQUE NOT NULL
);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

CREATE TABLE skdb_groups(
  groupID INTEGER PRIMARY KEY,
  readers STRING NOT NULL,
  is_public INTEGER
);

-- Passed this point The view skdb_groups_readers is created by the db.
CREATE INDEX skdb_groups_readers_readerID ON skdb_groups_readers(readerID);

