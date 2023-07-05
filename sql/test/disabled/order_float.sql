create table t1 (a FLOAT);

insert into t1 values(1.0);
insert into t1 values(111.0);
insert into t1 values(0.011);
insert into t1 values(-0.011);
insert into t1 values(-10.011);
insert into t1 values(10000.011);

select * from t1 order by a desc;
