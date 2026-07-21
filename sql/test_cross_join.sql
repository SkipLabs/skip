
create table t1(a INTEGER, b INTEGER UNIQUE);

insert into t1 values(22, 23);

create index t1b on t1(b);

select * from t1 where b = 23;
