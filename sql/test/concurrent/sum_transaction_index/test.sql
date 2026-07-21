CREATE TABLE t1(col0 INTEGER)
;

insert into t1 values(1);
insert into t1 values(1);


insert into t1 select * from t1;

select * from t1;
