-------------------------------------------------------------------------------
-- Creating the users
-------------------------------------------------------------------------------

insert into skdb_users values(id(), 'julienv');
insert into skdb_users values(id(), 'daniell');
insert into skdb_users values(id(), 'gregs');
insert into skdb_users values(id(), 'lucash');
insert into skdb_users values(id(), 'laurem');

-------------------------------------------------------------------------------
-- Creating a table of country codes associated with users.
-------------------------------------------------------------------------------

create table user_profiles(
  id INTEGER,
  full_name STRING,
  country_code STRING,
  skdb_privacy INTEGER,
  skdb_owner INTEGER
);

insert into user_profiles
  select userID, 'Julien Verlaguet', 'US', NULL, userID
  from skdb_users
  where username = 'julienv';

insert into user_profiles
  select userID, 'Daniel Lopes', 'FR', NULL, userID
  from skdb_users
  where username = 'daniell';

insert into user_profiles
  select userID, 'Greg Sexton', 'UK', NULL, userID
  from skdb_users
  where username = 'gregs';

insert into user_profiles
  select userID, 'Lucas Hosseini', 'FR', NULL, userID
  from skdb_users
  where username = 'lucash';

insert into user_profiles
  select userID, 'Laure Martin', 'FR',NULL, userID
  from skdb_users
  where username = 'laurem';

-------------------------------------------------------------------------------
-- Creating a visible table of users/groups.
-- By default, skdb_users is not visible, so we create a virtual table
-- with the column skdb_visibility set to NULL so that everybody can see it.
-------------------------------------------------------------------------------

create virtual view all_users as
  select userID, username, null as skdb_privacy from skdb_users;

create virtual view all_groups as
  select groupID, readers, null as skdb_privacy from skdb_groups;

-------------------------------------------------------------------------------
-- Creating whitelists, one is for skiplabs employees, the other for
-- skiplabs employees based in France.
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
  skdb_privacy INTEGER
);

create virtual view whitelist_skiplabs_employees_country as
  select userID, country_code
  from whitelist_skiplabs_employees, user_profiles
  where userID = id;

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
      where readers = 'whitelist_skiplabs_employees_admin'
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

-------------------------------------------------------------------------------
-- Posts
-------------------------------------------------------------------------------

create table posts (
  ID integer,
  data string,
  skdb_privacy integer,
  skdb_owner integer
);

insert into posts select 
   23,
   'my first post',
   (select groupID from skdb_groups where readers = 'whitelist_skiplabs_employees'),
   (select userID from skdb_users where username = 'julienv')
;

insert into posts select 
   24,
   'my first post for employees based in France',
   (select groupID from skdb_groups where readers = 'whitelist_skiplabs_employees_FR'),
   (select userID from skdb_users where username = 'lucash')
;

create virtual view readers_fid
  select cast(groupID as STRING) || '-' || cast(readerID as STRING) as fid
  from skdb_groups_readers
;

create virtual view posts_with_fid
  select
    cast(skdb_privacy as STRING) || '-' || cast(skdb_owner as STRING) as fid,
    data
  from posts
;

create virtual view visible_posts
  select p.fid, p.data
  from posts_with_fid as p, readers_fid as r
  where p.fid = r.fid
;

select * from visible_posts;

create virtual view posts_count as
  select count(*) as count, null as skdb_privacy from posts;

