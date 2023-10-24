create table t1 (a INTEGER, b INTEGER);
insert into t1 values(local_sequence_number(), 22);
select * from t1;
