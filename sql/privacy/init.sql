-------------------------------------------------------------------------------
-- Users
-------------------------------------------------------------------------------

create table skdb_users(
  userID integer primary key,
  username string unique not null,
  privateKey string not null
);

-------------------------------------------------------------------------------
-- Groups
-------------------------------------------------------------------------------

create table skdb_groups(
  groupID integer primary key,
  members string not null
);

-- Passed this point The view skdb_groups_members is created by the db.
create index skdb_groups_index on skdb_groups(members);
create index skdb_groups_members_memberID on skdb_groups_members(memberID);

create table whitelist_noone(userID integer);
create table blacklist_noone(userID integer);

insert into skdb_groups values (1, 'whitelist_noone');
insert into skdb_groups values (-1, 'blacklist_noone');

-------------------------------------------------------------------------------
-- Access
-------------------------------------------------------------------------------

create table skdb_access(
  accessID integer primary key,
  readersID integer not null,
  writersID integer not null,
  name string unique
);

create virtual view skdb_access_readers as select
  accessID integer,
  memberID integer
from skdb_access, skdb_groups_members
where readersID = groupID
;

create virtual view skdb_access_writers as select
  accessID integer,
  memberID integer
from skdb_access, skdb_groups_members
where writersID = groupID
;

insert into skdb_access values (-1, -1, -1, 'everyone');
