create table t1(a INTEGER);

create view v1 as select * from t1;

drop view v1;

create view v1 as select * from t1;

drop view v1;

create virtual view v1 as select * from t1;

drop view v1;
