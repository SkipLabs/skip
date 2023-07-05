create table t1 (a INTEGER, b INTEGER, c INTEGER);
create table t2 (a INTEGER, b INTEGER);
insert into t1 values (2, 3, 4);
insert into t2 values (2, 6);

select t1.*, t1.a+t1.b, t3.* from t1, t2 as t3 where t1.a = t3.a;
