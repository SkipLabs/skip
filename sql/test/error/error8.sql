create table t1 (a INTEGER);
create table t2 (a INTEGER, b INTEGER);

select * from t1 union select * from t2;

