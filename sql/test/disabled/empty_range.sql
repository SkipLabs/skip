create table t1 (a INTEGER primary key);
insert into t1 values (2);

create virtual view v1 as select * from t1 where a >= 2 and a <= 0;

insert into t1 values (23);
