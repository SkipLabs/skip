create table t1 (a INTEGER, b INTEGER);

insert into t1 values (1, 2), (2, 3);

select sum(a) from t1;
