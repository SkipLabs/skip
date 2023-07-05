create table T1 (a INTEGER PRIMARY KEY);

begin transaction;
  delete from t1;
  select * from t1 where a = 2;
commit;
