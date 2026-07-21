create table t (x integer, id integer primary key);
create table tt (y integer, id integer primary key);

insert into t values (100,1);
insert into tt values (42,1);

select t.* from t inner join tt on t.id = tt.id;
create reactive view vv as select t.* from t inner join tt on t.id = tt.id;
select * from vv;
