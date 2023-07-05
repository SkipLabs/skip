create table t1 (a INTEGER, b INTEGER);

insert into t1 values(2, 2);

update t1 set b = a + 1 where a = 2;


select * from t1;
