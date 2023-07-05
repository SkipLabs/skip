create table t1(a INTEGER PRIMARY KEY, b INTEGER);

begin transaction;
insert into t1 values (id('key1'), 123);
insert into t1 values (id('key2'), 122);
select b from t1 where a = id('key1');
select b from t1 where a = id('key2');
commit;
