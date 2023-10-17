create table t1(a STRING PRIMARY KEY, b INTEGER);

begin transaction;
insert into t1 values (sid('key1'), 123);
insert into t1 values (sid('key2'), 122);
select b from t1 where a = sid('key1');
select b from t1 where a = sid('key2');
commit;
