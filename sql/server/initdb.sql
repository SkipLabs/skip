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

create table users_country(id INTEGER, countryCode STRING, skdb_privacy INTEGER, skdb_owner INTEGER, present INTEGER, timestamp INTEGER);
create virtual view users_country_latest as
  select id, countryCode, skdb_privacy, present, max(timestamp) from users_country group by id;
create virtual view users_country_present as
  select id, countryCode, skdb_privacy from users_country_latest where present <> 0;

insert into users_country select userID, 'US', NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER) from skdb_users where userName = 'julienv';
insert into users_country select userID, 'FR', NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER) from skdb_users where userName = 'daniell';
insert into users_country select userID, 'UK', NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER) from skdb_users where userName = 'gregs';
insert into users_country select userID, 'FR', NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER) from skdb_users where userName = 'lucash';
insert into users_country select userID, 'FR', NULL, userID, 1, CAST(strftime('%s', 'now') AS INTEGER) from skdb_users where userName = 'laurem';

-------------------------------------------------------------------------------
-- Creating a visible table of users/groups.
-- By default, skdb_users is not visible, so we create a virtual table
-- with the column skdb_visibility set to NULL so that everybody can see it.
-------------------------------------------------------------------------------

create virtual view all_users as select userID, userName, null as skdb_privacy from skdb_users;
create virtual view all_groups as select groupID, readers, null as skdb_privacy from skdb_groups;

-------------------------------------------------------------------------------
-- Creating our first whitelist.
-------------------------------------------------------------------------------

create table whitelist_skiplabs_employees_modifs (userID INTEGER, skdb_privacy INTEGER, skdb_owner INTEGER, present INTEGER, timestamp INTEGER);
create virtual view whitelist_skiplabs_employees as select userID, present, max(timestamp) from whitelist_skiplabs_employees_modifs group by userID having present = 1;
create virtual view whitelist_skiplabs_employees_country as select userID, countryCode from whitelist_skiplabs_employees, users_country where userID = id;
create virtual view whitelist_skiplabs_employees_FR as select userID from whitelist_skiplabs_employees_country where countryCode = 'FR';


insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where userName = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)
  from all_users where userName = 'julienv';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where userName = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)
  from all_users where userName = 'daniell';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where userName = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)         
  from all_users where userName = 'gregs';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where userName = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)         
  from all_users where userName = 'lucash';

insert into whitelist_skiplabs_employees_modifs
  select userID,
         NULL,
         (select userID from skdb_users where userName = 'julienv'),
         1,
         CAST(strftime('%s', 'now') AS INTEGER)         
  from all_users where userName = 'laurem';


insert into skdb_groups values(id(), 'whitelist_skiplabs_employees');
insert into skdb_groups values(id(), 'whitelist_skiplabs_employees_FR');

create table posts (ID integer, skdb_privacy integer, skdb_owner integer, timestamp INTEGER, present INTEGER, data string);
insert into posts select 
  23,
  (select groupID from skdb_groups where readers = 'whitelist_skiplabs_employees'),
  (select userID from skdb_users where userName = 'julienv'),
  cast(strftime('%s', 'now') as INTEGER) * 1000,
  1,
  'my first post'
;

insert into posts select 
  23,
  (select groupID from skdb_groups where readers = 'whitelist_skiplabs_employees_FR'),
  (select userID from skdb_users where userName = 'lucash'),
  cast(strftime('%s', 'now') as INTEGER) * 1000,
  1,
  'my first post for employees based in France'
;

