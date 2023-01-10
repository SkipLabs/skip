create table t1 (a INTEGER PRIMARY KEY, b INTEGER);
insert into t1 values(22, 23);
insert into t1 values(24, 25);
insert or ignore into t1 values(22, 24);
insert or replace into t1 values(24, 26);
select * from t1;

