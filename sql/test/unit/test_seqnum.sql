create table t1(a INTEGER PRIMARY KEY, b INTEGER);

begin transaction;
insert into t1 values (local_sequence_number('key1'), 123);
insert into t1 values (local_sequence_number('key2'), 122);
select b from t1 where a = local_sequence_number('key1');
select b from t1 where a = local_sequence_number('key2');
commit;
