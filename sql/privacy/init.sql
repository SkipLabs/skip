-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

create table skdb_users(
  userid integer primary key,
  username string unique not null
);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

create table skdb_groups(
  groupid integer primary key,
  readers string not null
);

-- Passed this point The view skdb_groups_readers is created by the db.
create index skdb_groups_index on skdb_groups(readers);
create index skdb_groups_readers_readerid on skdb_groups_readers(readerid);

