-------------------------------------------------------------------------------
-- Creating the users
-------------------------------------------------------------------------------

insert into skdb_users values(id(), 'julienv');
insert into skdb_users values(id(), 'daniell');
insert into skdb_users values(id(), 'gregs');
insert into skdb_users values(id(), 'lucash');
insert into skdb_users values(id(), 'laurem');

create table profiles(
  skdb_owner INTEGER,
  full_name STRING,
  country_code STRING,
  skdb_access INTEGER,
  employer STRING
);

insert into profiles
  select userID, 'Julien Verlaguet', 'US', -1, 'skiplabs'
  from skdb_users
  where username = 'julienv'
;

insert into profiles
   select userID, 'Daniel Lopes', 'FR', -1, 'skiplabs'
   from skdb_users
   where username = 'daniell';

insert into profiles
  select userID, 'Greg Sexton', 'UK', -1, 'skiplabs'
  from skdb_users
  where username = 'gregs';

insert into profiles
  select userID, 'Lucas Hosseini', 'FR', -1, 'skiplabs'
  from skdb_users
  where username = 'lucash';

insert into profiles
  select userID, 'Laure Martin', 'FR', -1, 'skiplabs'
  from skdb_users
  where username = 'laurem';

-------------------------------------------------------------------------------
-- Creating a visible table of users/groups.
-- By default, skdb_users is not visible, so we create a virtual table
-- with the column skdb_visibility set to NULL so that everybody can see it.
-------------------------------------------------------------------------------

create virtual view all_users as
  select userID, username, -1 as skdb_access from skdb_users;

create virtual view all_groups as
  select groupID, members, -1 as skdb_access from skdb_groups;

-------------------------------------------------------------------------------
-- Creating a table of country codes associated with users.
-------------------------------------------------------------------------------

create virtual view whitelist_skiplabs_employees as
  select skdb_owner as userID from profiles where employer = 'skiplabs'
;

create virtual view whitelist_skiplabs_employees_FR as
  select skdb_owner as userID
  from profiles
  where employer = 'skiplabs' AND country_code = 'FR'
;

insert into skdb_groups values(id(), 'whitelist_skiplabs_employees');
insert into skdb_groups values(id(), 'whitelist_skiplabs_employees_FR');

insert into skdb_access select
  id(),
  groupID,
  groupID,
  'skiplabs_employees'
  from skdb_groups
  where members = 'whitelist_skiplabs_employees'
;

insert into skdb_access select
  id(),
  groupID,
  groupID,
  'skiplabs_employees_FR'
  from skdb_groups
  where members = 'whitelist_skiplabs_employees_FR'
;

-------------------------------------------------------------------------------
-- Friends
-------------------------------------------------------------------------------

create table friends (skdb_owner INTEGER, friend INTEGER, skdb_access INTEGER);

create table whitelist_julienv (userID integer);
insert into whitelist_julienv
  select userID from skdb_users where userName = 'julienv'
;
insert into skdb_groups values (id(), 'whitelist_julienv');

insert into skdb_access select
  id(),
  (select groupID
   from skdb_groups
   where members = 'whitelist_julienv'
  ),
  (select groupID
   from skdb_groups
   where members = 'whitelist_julienv'
  ),
  'julienv'
;

create virtual view whitelist_julienv_friends as
    select
      friend,
      (select accessID from skdb_access where name = 'julienv') as skdb_access
    from friends
    where
      skdb_owner = (select userID from skdb_users where userName = 'julienv')
  union
    select
      userID,
      (select accessID from skdb_access where name = 'julienv') as skdb_access
    from skdb_users
    where userName = 'julienv'
;
insert into skdb_groups values (id(), 'whitelist_julienv_friends');

insert into skdb_access select
  id(),
  (select groupID
   from skdb_groups
   where members = 'whitelist_julienv_friends'
  ),
  (select groupID
   from skdb_groups
   where members = 'whitelist_julienv'
  ),
  'julienv_friends'
;

-------------------------------------------------------------------------------
-- All access
-------------------------------------------------------------------------------

create virtual view all_access as
  select accessID,
         readers.members as readers,
         writers.members as writers,
         -1 as skdb_access
  from skdb_access, skdb_groups as readers, skdb_groups as writers
  where skdb_access.readersID = readers.groupID AND
        skdb_access.writersID = writers.groupID
;

-------------------------------------------------------------------------------
-- Posts
-------------------------------------------------------------------------------

create table posts (
  ID integer,
  data string,
  skdb_access integer not null,
  skdb_owner integer
);

insert into posts select
   23,
   'my first post for skiplabs employees',
   (select accessID from skdb_access where name = 'skiplabs_employees'),
   (select userID from skdb_users where username = 'julienv')
;

insert into posts select
   24,
   'my first post for employees based in France',
   (select accessID from skdb_access where name = 'skiplabs_employees_FR'),
   (select userID from skdb_users where username = 'julienv')
;

insert into posts select
   25,
   'my first post for my friends',
   (select accessID from skdb_access where name = 'julienv_friends'),
   (select userID from skdb_users where username = 'julienv')
;
