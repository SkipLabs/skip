create table T1 (a INTEGER PRIMARY KEY, b INTEGER);

insert into t1 values (2, 23);

begin transaction;
  delete from t1;
  update t1 set b = 2 where a = 2;
commit;
