create table t1 (a INTEGER, b INTEGER);
insert into t1 values (22, 23);

select *, a+b from t1;
