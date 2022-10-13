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

create user table user_profiles(
  id INTEGER,
  full_name STRING,
  country_code STRING,
  skdb_privacy INTEGER,
  skdb_owner INTEGER,
  skdb_present INTEGER,
  skdb_timestamp INTEGER
);

insert into user_profiles_modifs
  select userID, 'Julien Verlaguet', 'US',
         NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER)
  from skdb_users
  where username = 'julienv';

insert into user_profiles_modifs
  select userID, 'Daniel Lopes', 'FR',
         NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER)
  from skdb_users
  where username = 'daniell';

insert into user_profiles_modifs
  select userID, 'Greg Sexton', 'UK',
         NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER)
  from skdb_users
  where username = 'gregs';

insert into user_profiles_modifs
  select userID, 'Lucas Hosseini', 'FR',
         NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER)
  from skdb_users
  where username = 'lucash';

insert into user_profiles_modifs
  select userID, 'Laure Martin', 'FR',
         NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER)
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

create user table whitelist_skiplabs_employees (
  userID INTEGER,
  skdb_privacy INTEGER,
  skdb_owner INTEGER,
  skdb_present INTEGER,
  skdb_timestamp INTEGER
);

create virtual view whitelist_skiplabs_employees_country as
  select userID, country_code
  from whitelist_skiplabs_employees, user_profiles
  where userID = id;

create virtual view whitelist_skiplabs_employees_FR as
  select userID
  from whitelist_skiplabs_employees_country
  where country_code = 'FR';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where username = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)
  from all_users where username = 'julienv';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where username = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)
  from all_users where username = 'daniell';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where username = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)         
  from all_users where username = 'gregs';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where username = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)         
  from all_users where username = 'lucash';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where username = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)         
  from all_users where username = 'laurem';

insert into skdb_groups values(id(), 'whitelist_skiplabs_employees');
insert into skdb_groups values(id(), 'whitelist_skiplabs_employees_FR');

-------------------------------------------------------------------------------
-- Posts
-------------------------------------------------------------------------------

create user table posts (
  ID integer,
  data string,
  skdb_privacy integer,
  skdb_owner integer,
  skdb_timestamp INTEGER,
  skdb_present INTEGER
);

create virtual view posts_count as
  select count(*) as count, null as skdb_privacy from posts;

insert into posts_modifs select 
  23,
  'my first post',
  (select groupID from skdb_groups where readers = 'whitelist_skiplabs_employees'),
  (select userID from skdb_users where username = 'julienv'),
  cast(strftime('%s', 'now') as INTEGER) * 1000,
  1
;

insert into posts_modifs select 
  24,
  'my first post for employees based in France',
  (select groupID from skdb_groups where readers = 'whitelist_skiplabs_employees_FR'),
  (select userID from skdb_users where username = 'lucash'),
  cast(strftime('%s', 'now') as INTEGER) * 1000,
  1
;

