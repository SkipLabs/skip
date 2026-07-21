create table t1 (a INTEGER);
create table t2 (b INTEGER);

insert into t1 values(2);
insert into t2 values(2);
insert into t2 values(3);

select * from t1 inner join t2;

