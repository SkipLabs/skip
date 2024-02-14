create table t1 (a INTEGER PRIMARY KEY, b INTEGER);
create index t1_ab on t1(a);

create reactive view v1 as select * from t1;
create index v1_a on v1(a);
create index v1_b on v1(b);
