create table t1 (a TEXT);
insert into t1 values ('abc');
insert into t1 values ('def');

select * from t1 where a not like 'ab_';
