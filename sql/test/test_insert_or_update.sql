create table t1 (a INTEGER PRIMARY KEY, b INTEGER);

insert into t1 values (1, 2);

INSERT INTO t1 values (1, 2)
  ON CONFLICT (a) DO UPDATE SET b = 3;

select * from t1;

