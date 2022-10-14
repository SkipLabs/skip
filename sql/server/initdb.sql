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
  skdb_access INTEGER
);

insert into profiles
  select userID, 'Julien Verlaguet', 'US', -1
  from skdb_users
  where username = 'julienv'
;

insert into profiles
   select userID, 'Daniel Lopes', 'FR', -1
   from skdb_users
   where username = 'daniell';

insert into profiles
  select userID, 'Greg Sexton', 'UK', -1
  from skdb_users
  where username = 'gregs';

insert into profiles
  select userID, 'Lucas Hosseini', 'FR', -1
  from skdb_users
  where username = 'lucash';

insert into profiles
  select userID, 'Laure Martin', 'FR', -1
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

create table whitelist_skiplabs_employees_admin (
  userID INTEGER
);

insert into whitelist_skiplabs_employees_admin
  select userID from skdb_users
  where username = 'julienv'
;

insert into skdb_groups values(id(), 'whitelist_skiplabs_employees_admin');

create table whitelist_skiplabs_employees (
  userID INTEGER,
  skdb_access INTEGER
);

create virtual view whitelist_skiplabs_employees_country as
  select userID, country_code
  from whitelist_skiplabs_employees, profiles
  where userID = skdb_owner;

create virtual view whitelist_skiplabs_employees_FR as
  select userID
  from whitelist_skiplabs_employees_country
  where country_code = 'FR';

insert into whitelist_skiplabs_employees
  select
    userID,
    (
      select groupID
      from skdb_groups
      where members = 'whitelist_skiplabs_employees_admin'
    )
  from skdb_users
  where username = 'julienv' OR
        username = 'lucash' OR
        username = 'daniell' OR
        username = 'gregs' OR
        username = 'laurem'
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
   'my first post',
   (select accessID from skdb_access where name = 'skiplabs_employees'),
   (select userID from skdb_users where username = 'julienv')
;

insert into posts select 
   24,
   'my first post for employees based in France',
   (select accessID from skdb_access where name = 'skiplabs_employees_FR'),
   (select userID from skdb_users where username = 'lucash')
;

