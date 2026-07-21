create table t1(a INTEGER);

insert into t1 values (22);
insert into t1 values (NULL);
insert into t1 values (23);

select * from t1 order by 1 ASC;
select * from t1 order by 1 DESC;


create table t2 (a INTEGER, b INTEGER);
insert into t2 values(22, 23);
insert into t2 values(34, 24);
select a%4, sum(b) from t2 group by 1;

