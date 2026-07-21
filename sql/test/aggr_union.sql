create table t1(a INTEGER, b INTEGER);
create table t2(c INTEGER, d INTEGER);

insert into t1 values (1, 2);
insert into t1 values (2, 4);
insert into t2 values (1, 3);

select a from t1 union select sum(c) from t2;
select sum(a) from t1 union select c from t2;
select sum(a) from t1 union select sum(c) from t2;
