create table t1 (a INTEGER PRIMARY KEY, b INTEGER);

begin transaction;
insert into t1 values (local_sequence_number('key'), 1);
select a from t1 where a = local_sequence_number('key');
commit;

begin transaction;
insert into t1 values (local_sequence_number('key'), 2);
select a from t1 where a = local_sequence_number('key');
commit;

begin transaction;
insert into t1 values (local_sequence_number('key'), 3);
select local_sequence_number('key');
commit;

begin transaction;
insert into t1 values (local_sequence_number('key'), 4);
select local_sequence_number('key');
commit;
