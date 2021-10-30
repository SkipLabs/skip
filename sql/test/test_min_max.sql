create table t1(a INTEGER);

insert into t1 values (22);
insert into t1 values (23);

select min(a), max(a) from t1;
