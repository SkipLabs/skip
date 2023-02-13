create table t1 (a INTEGER, b INTEGER);
create virtual view v1 as select t1.* from t1;
create index v1_a on v1(a);
select * from v1 where a = 1;
