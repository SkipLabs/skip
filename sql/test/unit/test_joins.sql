create table t1(a INTEGER, b INTEGER);
create table t2(c INTEGER, d INTEGER);

insert into t1 values (1, 2);
insert into t1 values (2, 4);
insert into t2 values (1, 3);

select * from t1 left join t2 on a = c;
select * from t1 right join t2 on a = c;
select * from t1 full outer join t2 on a = c;

