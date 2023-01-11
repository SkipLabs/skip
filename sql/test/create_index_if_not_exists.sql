create table t1(a INTEGER);
create index t1_a on t1(a);
create index if not exists t1_a on t1(a);
select 22;
