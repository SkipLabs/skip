create table t1 (price INTEGER, id INTEGER primary key);
insert or ignore into t1 values (50, 1);
insert or ignore into t1 values (50, 2);
select * from t1;
