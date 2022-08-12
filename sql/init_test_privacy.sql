create table groupID1_readers (userID INTEGER UNIQUE NOT NULL);
create table groupID1_writers (userID INTEGER UNIQUE NOT NULL);

begin transaction;
insert into skdb_groups values (
  id('groupID1'),
  'groupID1_readers',
  'groupID1_writers',
  'groupID1'
);
select id('groupID1');
commit;


