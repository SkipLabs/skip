create table t1(a INTEGER, b INTEGER);
create table t2(c INTEGER, d INTEGER);
create table t3(e INTEGER, f INTEGER);

insert into t1 values (1, 4);
insert into t2 values (4, 4);
insert into t3 values (4, 6);

select * from t3, t2, t1 where e = b AND c = b;
